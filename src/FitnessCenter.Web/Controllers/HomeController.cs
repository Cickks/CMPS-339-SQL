using Microsoft.AspNetCore.Mvc;

namespace FitnessCenter.Web.Controllers;

public sealed class HomeController : Controller
{
    public IActionResult Index()
    {
        return User.Identity?.IsAuthenticated == true
            ? RedirectToAction("Index", "Dashboard")
            : RedirectToAction("Login", "Account");
    }
}
