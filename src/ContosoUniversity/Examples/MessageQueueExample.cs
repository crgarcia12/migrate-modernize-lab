using System;
using System.Threading.Tasks;
using ContosoUniversity.Infrastructure;
using ContosoUniversity.Models;
using ContosoUniversity.Services;

namespace ContosoUniversity.Examples
{
    /// <summary>
    /// Example demonstrating the usage of the custom MessageQueue implementation
    /// </summary>
    public class MessageQueueExample
    {
        public void BasicQueueOperations()
        {
            // Create a new queue
            var queuePath = "TestQueue";
            var queue = MessageQueue.Create(queuePath);

            // Send messages
            queue.Send("Hello World!", "Simple String Message");
            queue.Send(new { Name = "John", Age = 30 }, "JSON Object");

            // Receive messages
            var message1 = queue.Receive();
            Console.WriteLine($"Received: {message1.Body}, Label: {message1.Label}");

            var message2 = queue.Receive();
            Console.WriteLine($"Received: {message2.Body}, Label: {message2.Label}");

            // Clean up
            MessageQueue.Delete(queuePath);
        }

        public void NotificationServiceExample(NotificationService notificationService)
        {

            // Send some notifications
            notificationService.SendNotification("Student", "123", "John Doe", EntityOperation.CREATE, "admin");
            notificationService.SendNotification("Course", "456", "Mathematics", EntityOperation.UPDATE, "teacher");
            notificationService.SendNotification("Department", "789", EntityOperation.DELETE, "admin");

            // Receive notifications
            Notification notification;
            while ((notification = notificationService.ReceiveNotification()) != null)
            {
                Console.WriteLine($"Notification: {notification.Message}");
                Console.WriteLine($"Created by: {notification.CreatedBy} at {notification.CreatedAt}");
                Console.WriteLine("---");
            }

            notificationService.Dispose();
        }

        public async Task AsyncQueueOperations()
        {
            var queueManager = MessageQueueManager.Create("AsyncQueue");
            
            // Send messages
            queueManager.Send("Async Message 1", "Label1");
            queueManager.Send("Async Message 2", "Label2");

            // Receive messages asynchronously
            try
            {
                var message = await queueManager.ReceiveAsync(TimeSpan.FromSeconds(5));
                Console.WriteLine($"Async received: {message.Body}");
            }
            catch (TimeoutException)
            {
                Console.WriteLine("No messages received within timeout");
            }

            MessageQueueManager.Delete("AsyncQueue");
        }

        public void QueueManagementOperations()
        {
            // Create multiple queues
            MessageQueueManager.Create("Queue1");
            MessageQueueManager.Create("Queue2");
            MessageQueueManager.Create("Queue3");

            // List all queues
            Console.WriteLine("Available queues:");
            foreach (var queueName in MessageQueueManager.GetAllQueueNames())
            {
                Console.WriteLine($"- {queueName}");
            }

            // Check if queue exists
            if (MessageQueueManager.Exists("Queue1"))
            {
                Console.WriteLine("Queue1 exists");
            }

            // Get queue and send message
            var queue1 = MessageQueueManager.GetQueue("Queue1");
            queue1.Send("Test message for Queue1");

            Console.WriteLine($"Queue1 has {queue1.Count} messages");

            // Clean up all queues
            MessageQueueManager.ClearAll();
        }

        public void ErrorHandlingExample()
        {
            try
            {
                // Try to get a non-existent queue
                var queue = MessageQueueManager.GetQueue("NonExistentQueue");
            }
            catch (InvalidOperationException ex)
            {
                Console.WriteLine($"Error: {ex.Message}");
            }

            try
            {
                // Try to receive from empty queue with short timeout
                var queue = MessageQueue.Create("EmptyQueue");
                var message = queue.Receive(TimeSpan.FromMilliseconds(100));
            }
            catch (TimeoutException ex)
            {
                Console.WriteLine($"Timeout: {ex.Message}");
            }
            finally
            {
                MessageQueue.Delete("EmptyQueue");
            }
        }
    }
}