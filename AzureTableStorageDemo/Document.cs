using System;
using Microsoft.WindowsAzure.Storage.Table;

namespace ATSdemo
{
    /// <summary>
    /// Todo: Complex types
    /// </summary>
    public class Document : TableEntity
    {
        public Guid Id { get; set; }
        public  string Url { get; set; }
        public byte[]  ByteArray { get; set; }
        public bool Boolean { get; set; }
        public DateTime DateTime { get; set; }
        public double Double { get; set; }
        public int Integer { get; set; }

        /// <summary>
        /// Empty ctor required
        /// </summary>
        public Document()
        {
        }

        public Document(Guid id, string url, byte[] byteArray, bool boolean, DateTime dateTime, double d, int integer)
        {
            Id = id;
            Url = url;
            ByteArray = byteArray;
            Boolean = boolean;
            DateTime = dateTime;
            Double = d;
            Integer = integer;
            PartitionKey = id.ToString(); ;
            RowKey = id.ToString();
        }
    }
}