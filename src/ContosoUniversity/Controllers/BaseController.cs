using System;
using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using ContosoUniversity.Services;
using ContosoUniversity.Models;
using ContosoUniversity.Data;

namespace ContosoUniversity.Controllers
{
    public abstract class BaseController : Controller
    {
        protected SchoolContext db;
        protected NotificationService notificationService;

        public BaseController(SchoolContext context, NotificationService notificationSvc)
        {
            db = context;
            notificationService = notificationSvc;
        }

        protected void SendEntityNotification(string entityType, string entityId, EntityOperation operation)
        {
            SendEntityNotification(entityType, entityId, null, operation);
        }

        protected void SendEntityNotification(string entityType, string entityId, string entityDisplayName, EntityOperation operation)
        {
            try
            {
                var userName = User?.Identity?.IsAuthenticated == true
                    ? (User.FindFirst("name")?.Value ?? User.Identity.Name ?? "Unknown")
                    : "System";
                notificationService.SendNotification(entityType, entityId, entityDisplayName, operation, userName);
            }
            catch (Exception ex)
            {
                // Log the error but don't break the main operation
                System.Diagnostics.Debug.WriteLine($"Failed to send notification: {ex.Message}");
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db?.Dispose();
                notificationService?.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
