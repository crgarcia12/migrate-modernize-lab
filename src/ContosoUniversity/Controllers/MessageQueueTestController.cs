using System;
using Microsoft.AspNetCore.Mvc;
using ContosoUniversity.Infrastructure;
using ContosoUniversity.Services;
using ContosoUniversity.Models;
using ContosoUniversity.Data;

namespace ContosoUniversity.Controllers
{
    public class MessageQueueTestController : BaseController
    {
        public MessageQueueTestController(SchoolContext context, NotificationService notificationSvc)
            : base(context, notificationSvc) { }

        public ActionResult Index()
        {
            ViewBag.Message = "Message Queue Test Page";
            return View();
        }

        [HttpPost]
        public ActionResult SendTestNotification()
        {
            try
            {
                notificationService.SendNotification(
                    "Test", 
                    Guid.NewGuid().ToString(), 
                    "Test Entity", 
                    EntityOperation.CREATE, 
                    User?.Identity?.Name ?? "TestUser"
                );

                ViewBag.Message = "Test notification sent successfully!";
                ViewBag.MessageType = "success";
            }
            catch (Exception ex)
            {
                ViewBag.Message = $"Error sending notification: {ex.Message}";
                ViewBag.MessageType = "error";
            }

            return View("Index");
        }

        [HttpPost]
        public ActionResult ReceiveNotifications()
        {
            try
            {
                var notifications = new System.Collections.Generic.List<Notification>();
                Notification notification;
                
                // Try to receive up to 10 notifications
                int count = 0;
                while ((notification = notificationService.ReceiveNotification()) != null && count < 10)
                {
                    notifications.Add(notification);
                    count++;
                }

                ViewBag.Notifications = notifications;
                ViewBag.Message = $"Received {notifications.Count} notifications";
                ViewBag.MessageType = "info";
            }
            catch (Exception ex)
            {
                ViewBag.Message = $"Error receiving notifications: {ex.Message}";
                ViewBag.MessageType = "error";
            }

            return View("Index");
        }

        [HttpPost]
        public ActionResult TestBasicQueue()
        {
            try
            {
                var queueName = "TestBasicQueue";
                var queue = MessageQueue.Create(queueName);

                // Send test messages
                queue.Send("Hello World!", "Test Message 1");
                queue.Send(new { TestData = "JSON Object", Timestamp = DateTime.Now }, "Test Message 2");

                // Receive messages
                var message1 = queue.Receive();
                var message2 = queue.Receive();

                ViewBag.Message = $"Basic queue test completed. Received: '{message1.Body}' and '{message2.Body}'";
                ViewBag.MessageType = "success";

                // Clean up
                MessageQueue.Delete(queueName);
            }
            catch (Exception ex)
            {
                ViewBag.Message = $"Error in basic queue test: {ex.Message}";
                ViewBag.MessageType = "error";
            }

            return View("Index");
        }

        [HttpPost]
        public ActionResult GetQueueStatus()
        {
            try
            {
                var queueNames = MessageQueueManager.GetAllQueueNames();
                var status = new System.Text.StringBuilder();
                
                status.AppendLine("Queue Status:");
                foreach (var queueName in queueNames)
                {
                    var queue = MessageQueueManager.GetQueue(queueName);
                    status.AppendLine($"- {queueName}: {queue.Count} messages");
                }

                if (status.Length == "Queue Status:".Length + Environment.NewLine.Length)
                {
                    status.AppendLine("No queues found");
                }

                ViewBag.Message = status.ToString();
                ViewBag.MessageType = "info";
            }
            catch (Exception ex)
            {
                ViewBag.Message = $"Error getting queue status: {ex.Message}";
                ViewBag.MessageType = "error";
            }

            return View("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                notificationService?.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}