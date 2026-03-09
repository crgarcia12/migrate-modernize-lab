using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using ContosoUniversity.Data;
using ContosoUniversity.Models.SchoolViewModels;
using ContosoUniversity.Services;

namespace ContosoUniversity.Controllers
{
    public class HomeController : BaseController
    {
        public HomeController(SchoolContext context, NotificationService notificationSvc)
            : base(context, notificationSvc) { }
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            IQueryable<EnrollmentDateGroup> data = 
                from student in db.Students
                group student by student.EnrollmentDate into dateGroup
                select new EnrollmentDateGroup()
                {
                    EnrollmentDate = dateGroup.Key,
                    StudentCount = dateGroup.Count()
                };
            return View(data.ToList());
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public ActionResult Error()
        {
            return View();
        }

        public ActionResult AccessDenied()
        {
            ViewBag.Message = "You don't have permission to access this resource.";
            return View();
        }
    }
}
