namespace PushMessages
{
    using Microsoft.WindowsAzure.Storage.Queue;
    using Newtonsoft.Json;
    using System;
    using System.Configuration;

    class PushPayload
    {
        private static readonly Uri QueueUri = new Uri(ConfigurationManager.AppSettings["queueUriWithSasToken"]);
        private static readonly CloudQueue CloudQueue = new CloudQueue(QueueUri);

        static void Main(string[] args)
        {
            var payload = JsonConvert.SerializeObject(
                new
                {
                    param1 = "value1",
                    param2 = "value2"
                });

            var message = new CloudQueueMessage(payload);
            CloudQueue.AddMessage(message);
        }
    }
}
