namespace FitnessCenter.Web.Models;

public sealed record DashboardMetrics(
    int TotalMembers,
    int ActiveMemberships,
    int ScheduledClasses,
    int TotalCheckIns,
    int PrivateSessions,
    int Payments);

public sealed record MemberSummary(
    int MemberId,
    string FullName,
    string MemberStatus,
    DateTime JoinDate,
    string? PlanName,
    string? MembershipStatus);

public sealed record ClassScheduleSummary(
    int ScheduleId,
    string ClassName,
    DateTime ScheduleTime,
    string TrainerName,
    string RoomName,
    int MaxCapacity);

public sealed record AttendanceSummary(
    int MemberId,
    string MemberName,
    string ClassName,
    DateTime ScheduleTime,
    DateTime CheckInTime,
    int? MemberRating);

public sealed record ClassRatingSummary(
    int ClassId,
    string ClassName,
    decimal? AverageRating,
    int RatingCount);

public sealed record AttendancePageViewModel(
    IReadOnlyList<AttendanceSummary> CheckIns,
    IReadOnlyList<ClassRatingSummary> Ratings);

public sealed record PrivateSessionSummary(
    int PrivateSessionId,
    string MemberName,
    string TrainerName,
    string? RoomName,
    DateTime SessionDate,
    TimeSpan StartTime,
    int DurationMinutes,
    decimal SessionFee,
    string SessionStatus,
    string FocusArea);

public sealed record PaymentSummary(
    int PaymentId,
    string MemberName,
    DateTime PaymentDate,
    decimal Amount,
    string PaymentMethod,
    string PaymentStatus,
    string PaymentFor);

public sealed record TrainerRevenueSummary(
    int TrainerId,
    string TrainerName,
    string Specialization,
    int CompletedSessions,
    decimal TotalSessionHours,
    decimal TotalRevenue);

public sealed record PaymentsPageViewModel(
    IReadOnlyList<PaymentSummary> Payments,
    IReadOnlyList<TrainerRevenueSummary> TrainerRevenue);

public sealed record DataErrorViewModel(
    string Title,
    string Message,
    string RetryAction);
