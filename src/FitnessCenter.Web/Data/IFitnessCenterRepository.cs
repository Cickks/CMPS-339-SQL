using FitnessCenter.Web.Models;

namespace FitnessCenter.Web.Data;

public interface IFitnessCenterRepository
{
    Task<DashboardMetrics> GetMetricsAsync(CancellationToken cancellationToken);

    Task<IReadOnlyList<MemberSummary>> GetMembersAsync(
        CancellationToken cancellationToken);

    Task<IReadOnlyList<ClassScheduleSummary>> GetClassSchedulesAsync(
        CancellationToken cancellationToken);

    Task<IReadOnlyList<AttendanceSummary>> GetAttendanceAsync(
        CancellationToken cancellationToken);

    Task<IReadOnlyList<ClassRatingSummary>> GetClassRatingsAsync(
        CancellationToken cancellationToken);

    Task<IReadOnlyList<PrivateSessionSummary>> GetPrivateSessionsAsync(
        CancellationToken cancellationToken);

    Task<IReadOnlyList<PaymentSummary>> GetPaymentsAsync(
        CancellationToken cancellationToken);

    Task<IReadOnlyList<TrainerRevenueSummary>> GetTrainerRevenueAsync(
        CancellationToken cancellationToken);
}
