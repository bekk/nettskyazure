using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.WindowsAzure.Storage.RetryPolicies;
using Microsoft.WindowsAzure.Storage.Table;
using Microsoft.WindowsAzure.Storage.Table.Queryable;

namespace ATSdemo
{
    public class Program
    {
        static void Main()
        {

            var anyId = Guid.NewGuid();
            var anyByteArray = new byte[] { 0xBA, 0xDD, 0xCA, 0xFE };
            const bool anyBool = true;
            var anyDateTime = DateTime.Now;
            const double anyDouble = 3.14159265359D;
            const int anyInt = 42;

            var storageAccount = CloudStorageAccount.Parse(CloudConfigurationManager.GetSetting("StorageConnectionString"));

            var blobClient = storageAccount.CreateCloudBlobClient();
            var container = blobClient.GetContainerReference("mydocuments");
            container.CreateIfNotExists();
            container.SetPermissions(new BlobContainerPermissions { PublicAccess = BlobContainerPublicAccessType.Blob });
            var blob = container.GetBlockBlobReference($"doc-{anyId}.html");
            blob.Properties.ContentType = "text/html";
            blob.UploadText(
                "<html>" +
                    "<body>" +
                       $"<h2>This is a document {anyId}</h2>" +
                        "<p>" +
                        "<img src='https://jamiehickmanvi.files.wordpress.com/2013/09/animated-gif.gif' />" +
                        "</p>" +
                    "</body>" +
                "</html>"
                , Encoding.UTF8);
            Console.WriteLine($"Blob {blob.Name} uploaded.\n");

            var tableClient = storageAccount.CreateCloudTableClient();
            tableClient.DefaultRequestOptions = new TableRequestOptions{RetryPolicy = new ExponentialRetry(TimeSpan.FromSeconds(2), 10)};
            var table = tableClient.GetTableReference("Documents");
            table.CreateIfNotExists();

            /*
             * Insert data via TableEntity 
             */
            var doc = new Document(anyId, blob.Uri.ToString(), anyByteArray, anyBool, anyDateTime, anyDouble, anyInt);
            var insertOperation = TableOperation.Insert(doc);
            table.Execute(insertOperation);
            Console.WriteLine($"Entity {doc.Id} inserted.\n");

            table.Execute(TableOperation.Retrieve("partitionkey", "rowid"));

            /* 
             * Insert data via DynamicTableEntity
             */
            var entity = new DynamicTableEntity(
                "partitionkey", 
                "rowid",
                "*", // user for concurency
                new Dictionary<string, EntityProperty>{
                {"Property", new EntityProperty("stringVal")},
                {"Property2", new EntityProperty(DateTimeOffset.UtcNow)},
                    });

            //save the entity
            table.Execute(TableOperation.InsertOrReplace(entity));

            //retrieve the entity
            table.Execute(TableOperation.Retrieve("partitionKey", "rowKey"));


          
            Console.WriteLine($"Get single Document {anyId}  ...");

            var retrieveOperation = TableOperation.Retrieve<Document>(anyId.ToString(), anyId.ToString());

            var retrievedResult = table.Execute(retrieveOperation);

            Console.WriteLine( $"\t{((Document)retrievedResult.Result).Id}\n");

            var query = table
                .CreateQuery<Document>()
                .Where(c => c.DateTime < DateTime.Now && c.DateTime > DateTime.Now.Subtract(TimeSpan.FromDays(7)))
                .Take(10);

            var results = table.ExecuteQuery(query.AsTableQuery());
            Console.WriteLine("Searching for all documents from the past 7 days ...");
            foreach (var result in results)
            {
                Console.WriteLine($"\t{result.Id}\t[{result.DateTime}]");
            }

            Console.WriteLine("\nPRESS A KEY TO EXIT");
            Console.ReadKey();
        }
    }
}
