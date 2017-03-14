using System.Collections.Generic;
using System.Security.Claims;
using System.Web.Mvc;

namespace AzureAdAuth.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ClaimsIdentity claimsId = ClaimsPrincipal.Current.Identity as ClaimsIdentity;
            var appRoles = new List<string>();
            foreach (Claim claim in ClaimsPrincipal.Current.FindAll(claimsId.RoleClaimType))
                appRoles.Add(claim.Value);
            ViewData["appRoles"] = appRoles;
            return View();
        }

        /// <summary>
        /// Add a new task to the database or Update the Status of an Existing Task.  Requires that
        /// the user has a application role of Admin, Writer, or Approver, and only allows certain actions based
        /// on which role(s) the user has been granted.
        /// </summary>
        /// <param name="formCollection">The user input including task name and status.</param>
        /// <returns>A Redirect to the Tasks Page.</returns>
        [Authorize(Roles = "Admin")]
        public ActionResult CheckMe()
        {
            if (User.IsInRole("Admin") || User.IsInRole("Writer"))
            {
               
            }

            return RedirectToAction("Index", "Tasks");
        }
    }
}