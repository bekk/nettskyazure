using System;
using System.Configuration;
using System.Threading;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.WindowsAzure.Storage.Queue;

namespace PopMessages
{
    class PopPayload
    {
        private static readonly Uri QueueUri = new Uri(ConfigurationManager.AppSettings["queueUriWithSasToken"]);
        private static readonly Uri BlobUri = new Uri(ConfigurationManager.AppSettings["containerUriWithSasToken"]);
        private static readonly CloudQueue CloudQueue = new CloudQueue(QueueUri);
        private static readonly CloudBlobContainer CloudBlob = new CloudBlobContainer(BlobUri);

        static void Main(string[] args)
        {


            while (true)
            {
                CloudQueueMessage message;

                while ((message = CloudQueue.GetMessage()) != null)
                {
                    try
                    {
                        if (message.DequeueCount > 5)
                            Console.WriteLine("Message unprocessable  {0} ", message.Id);
                        else
                            ProcessMessage(message);

                        CloudQueue.DeleteMessageAsync(message);
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine("{0}/n{1}", message, e.Message);
                    }
                }

                Thread.Sleep(2500);
            }
        }

        private static void ProcessMessage(CloudQueueMessage msg)
        {
            Console.WriteLine(msg.AsString);
            
            CloudBlob
                .GetBlockBlobReference($"export{msg.Id}.csv")
                .UploadText("column1;column2");
        }

    }
}
