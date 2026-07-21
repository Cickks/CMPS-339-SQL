using FitnessCenter.Web.Data;
using FitnessCenter.Web.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace FitnessCenter.Web.Controllers;

[Authorize(Roles = "Admin")]
public sealed class DashboardController(
    IFitnessCenterRepository repository,
    ILogger<DashboardController> logger) : Controller
{
    public async Task<IActionResult> Index(CancellationToken cancellationToken)
    {
        try
        {
            return View(await repository.GetMetricsAsync(cancellationToken));
        }
        catch (Exception exception) when (IsDataAccessFailure(exception))
        {
            return DataError(exception, nameof(Index));
        }
    }

    public async Task<IActionResult> Members(CancellationToken cancellationToken)
    {
        try
        {
            return View(await repository.GetMembersAsync(cancellationToken));
        }
        catch (Exception exception) when (IsDataAccessFailure(exception))
        {
            return DataError(exception, nameof(Members));
        }
    }

    public async Task<IActionResult> Classes(CancellationToken cancellationToken)
    {
        try
        {
            return View(await repository.GetClassSchedulesAsync(cancellationToken));
        }
        catch (Exception exception) when (IsDataAccessFailure(exception))
        {
            return DataError(exception, nameof(Classes));
        }
    }

    public async Task<IActionResult> Attendance(CancellationToken cancellationToken)
    {
        try
        {
            var checkIns = await repository.GetAttendanceAsync(cancellationToken);
            var ratings = await repository.GetClassRatingsAsync(cancellationToken);
            return View(new AttendancePageViewModel(checkIns, ratings));
        }
        catch (Exception exception) when (IsDataAccessFailure(exception))
        {
            return DataError(exception, nameof(Attendance));
        }
    }

    public async Task<IActionResult> Sessions(CancellationToken cancellationToken)
    {
        try
        {
            return View(await repository.GetPrivateSessionsAsync(cancellationToken));
        }
        catch (Exception exception) when (IsDataAccessFailure(exception))
        {
            return DataError(exception, nameof(Sessions));
        }
    }

    public async Task<IActionResult> Payments(CancellationToken cancellationToken)
    {
        try
        {
            var payments = await repository.GetPaymentsAsync(cancellationToken);
            var revenue = await repository.GetTrainerRevenueAsync(cancellationToken);
            return View(new PaymentsPageViewModel(payments, revenue));
        }
        catch (Exception exception) when (IsDataAccessFailure(exception))
        {
            return DataError(exception, nameof(Payments));
        }
    }

    private IActionResult DataError(Exception exception, string retryAction)
    {
        logger.LogError(
            exception,
            "Dashboard data could not be loaded for action {ActionName}.",
            retryAction);

        Response.StatusCode = StatusCodes.Status503ServiceUnavailable;
        return View(
            "DataError",
            new DataErrorViewModel(
                "Database unavailable",
                "The dashboard could not reach the local FitnessCenterDB. Check Docker and the local setup, then try again.",
                retryAction));
    }

    private static bool IsDataAccessFailure(Exception exception)
    {
        return exception is SqlException
            or InvalidOperationException
            or TimeoutException;
    }
}
