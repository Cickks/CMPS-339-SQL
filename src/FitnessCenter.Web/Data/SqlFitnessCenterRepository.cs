using FitnessCenter.Web.Models;
using Microsoft.Data.SqlClient;

namespace FitnessCenter.Web.Data;

public sealed class SqlFitnessCenterRepository(
    IConfiguration configuration) : IFitnessCenterRepository
{
    private readonly string _connectionString =
        configuration.GetConnectionString("FitnessCenterDb")
        ?? throw new InvalidOperationException(
            "The FitnessCenterDb connection string is not configured.");

    public async Task<DashboardMetrics> GetMetricsAsync(
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                (SELECT COUNT(*) FROM Members) AS TotalMembers,
                (SELECT COUNT(*) FROM MemberMemberships
                    WHERE MembershipStatus = 'Active') AS ActiveMemberships,
                (SELECT COUNT(*) FROM ClassSchedules) AS ScheduledClasses,
                (SELECT COUNT(*) FROM ClassAttendance) AS TotalCheckIns,
                (SELECT COUNT(*) FROM PrivateSessions) AS PrivateSessions,
                (SELECT COUNT(*) FROM Payments) AS Payments;
            """;

        await using var connection = await OpenConnectionAsync(cancellationToken);
        await using var command = new SqlCommand(sql, connection);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);

        if (!await reader.ReadAsync(cancellationToken))
        {
            return new DashboardMetrics(0, 0, 0, 0, 0, 0);
        }

        return new DashboardMetrics(
            reader.GetInt32(0),
            reader.GetInt32(1),
            reader.GetInt32(2),
            reader.GetInt32(3),
            reader.GetInt32(4),
            reader.GetInt32(5));
    }

    public async Task<IReadOnlyList<MemberSummary>> GetMembersAsync(
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                m.MemberID,
                CONCAT(m.FirstName, ' ', m.LastName) AS FullName,
                m.MemberStatus,
                m.JoinDate,
                currentMembership.PlanName,
                currentMembership.MembershipStatus
            FROM Members AS m
            OUTER APPLY
            (
                SELECT TOP (1)
                    mp.PlanName,
                    mm.MembershipStatus
                FROM MemberMemberships AS mm
                INNER JOIN MembershipPlans AS mp
                    ON mp.MembershipPlanID = mm.MembershipPlanID
                WHERE mm.MemberID = m.MemberID
                ORDER BY
                    CASE WHEN mm.MembershipStatus = 'Active' THEN 0 ELSE 1 END,
                    mm.StartDate DESC,
                    mm.MemberMembershipID DESC
            ) AS currentMembership
            ORDER BY m.LastName, m.FirstName, m.MemberID;
            """;

        var members = new List<MemberSummary>();
        await using var connection = await OpenConnectionAsync(cancellationToken);
        await using var command = new SqlCommand(sql, connection);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);

        while (await reader.ReadAsync(cancellationToken))
        {
            members.Add(new MemberSummary(
                reader.GetInt32(0),
                reader.GetString(1),
                reader.GetString(2),
                reader.GetDateTime(3),
                reader.IsDBNull(4) ? null : reader.GetString(4),
                reader.IsDBNull(5) ? null : reader.GetString(5)));
        }

        return members;
    }

    public async Task<IReadOnlyList<ClassScheduleSummary>> GetClassSchedulesAsync(
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                s.ScheduleID,
                c.ClassName,
                s.ScheduleTime,
                CONCAT(t.FirstName, ' ', t.LastName) AS TrainerName,
                r.RoomName,
                s.MaxCapacity
            FROM ClassSchedules AS s
            INNER JOIN GroupClasses AS c ON c.ClassID = s.ClassID
            INNER JOIN Trainers AS t ON t.TrainerID = s.TrainerID
            INNER JOIN Rooms AS r ON r.RoomID = s.RoomID
            ORDER BY s.ScheduleTime, c.ClassName, s.ScheduleID;
            """;

        var schedules = new List<ClassScheduleSummary>();
        await using var connection = await OpenConnectionAsync(cancellationToken);
        await using var command = new SqlCommand(sql, connection);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);

        while (await reader.ReadAsync(cancellationToken))
        {
            schedules.Add(new ClassScheduleSummary(
                reader.GetInt32(0),
                reader.GetString(1),
                reader.GetDateTime(2),
                reader.GetString(3),
                reader.GetString(4),
                reader.GetInt32(5)));
        }

        return schedules;
    }

    public async Task<IReadOnlyList<AttendanceSummary>> GetAttendanceAsync(
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                MemberID,
                CONCAT(MemberFirstName, ' ', MemberLastName) AS MemberName,
                ClassName,
                ScheduleTime,
                CheckInTime,
                MemberRating
            FROM vw_MemberCheckInLog
            ORDER BY CheckInTime DESC, MemberID;
            """;

        var attendance = new List<AttendanceSummary>();
        await using var connection = await OpenConnectionAsync(cancellationToken);
        await using var command = new SqlCommand(sql, connection);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);

        while (await reader.ReadAsync(cancellationToken))
        {
            attendance.Add(new AttendanceSummary(
                reader.GetInt32(0),
                reader.GetString(1),
                reader.GetString(2),
                reader.GetDateTime(3),
                reader.GetDateTime(4),
                reader.IsDBNull(5) ? null : reader.GetInt32(5)));
        }

        return attendance;
    }

    public async Task<IReadOnlyList<ClassRatingSummary>> GetClassRatingsAsync(
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                c.ClassID,
                c.ClassName,
                AVG(CAST(a.MemberRating AS DECIMAL(4, 2))) AS AverageRating,
                COUNT(a.MemberRating) AS RatingCount
            FROM GroupClasses AS c
            LEFT JOIN ClassSchedules AS s ON s.ClassID = c.ClassID
            LEFT JOIN ClassAttendance AS a ON a.ScheduleID = s.ScheduleID
            GROUP BY c.ClassID, c.ClassName
            ORDER BY c.ClassName, c.ClassID;
            """;

        var ratings = new List<ClassRatingSummary>();
        await using var connection = await OpenConnectionAsync(cancellationToken);
        await using var command = new SqlCommand(sql, connection);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);

        while (await reader.ReadAsync(cancellationToken))
        {
            ratings.Add(new ClassRatingSummary(
                reader.GetInt32(0),
                reader.GetString(1),
                reader.IsDBNull(2) ? null : reader.GetDecimal(2),
                reader.GetInt32(3)));
        }

        return ratings;
    }

    public async Task<IReadOnlyList<PrivateSessionSummary>> GetPrivateSessionsAsync(
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                ps.PrivateSessionID,
                CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
                CONCAT(t.FirstName, ' ', t.LastName) AS TrainerName,
                r.RoomName,
                ps.SessionDate,
                ps.StartTime,
                ps.DurationMinutes,
                ps.SessionFee,
                ps.SessionStatus,
                ps.FocusArea
            FROM PrivateSessions AS ps
            INNER JOIN Members AS m ON m.MemberID = ps.MemberID
            INNER JOIN Trainers AS t ON t.TrainerID = ps.TrainerID
            LEFT JOIN Rooms AS r ON r.RoomID = ps.RoomID
            ORDER BY ps.SessionDate DESC, ps.StartTime DESC, ps.PrivateSessionID;
            """;

        var sessions = new List<PrivateSessionSummary>();
        await using var connection = await OpenConnectionAsync(cancellationToken);
        await using var command = new SqlCommand(sql, connection);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);

        while (await reader.ReadAsync(cancellationToken))
        {
            sessions.Add(new PrivateSessionSummary(
                reader.GetInt32(0),
                reader.GetString(1),
                reader.GetString(2),
                reader.IsDBNull(3) ? null : reader.GetString(3),
                reader.GetDateTime(4),
                reader.GetTimeSpan(5),
                reader.GetInt32(6),
                reader.GetDecimal(7),
                reader.GetString(8),
                reader.GetString(9)));
        }

        return sessions;
    }

    public async Task<IReadOnlyList<PaymentSummary>> GetPaymentsAsync(
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                p.PaymentID,
                CONCAT(m.FirstName, ' ', m.LastName) AS MemberName,
                p.PaymentDate,
                p.Amount,
                p.PaymentMethod,
                p.PaymentStatus,
                CASE
                    WHEN p.MemberMembershipID IS NOT NULL
                        THEN CONCAT('Membership: ', mp.PlanName)
                    ELSE CONCAT('Private session #', p.PrivateSessionID)
                END AS PaymentFor
            FROM Payments AS p
            INNER JOIN Members AS m ON m.MemberID = p.MemberID
            LEFT JOIN MemberMemberships AS mm
                ON mm.MemberMembershipID = p.MemberMembershipID
            LEFT JOIN MembershipPlans AS mp
                ON mp.MembershipPlanID = mm.MembershipPlanID
            ORDER BY p.PaymentDate DESC, p.PaymentID DESC;
            """;

        var payments = new List<PaymentSummary>();
        await using var connection = await OpenConnectionAsync(cancellationToken);
        await using var command = new SqlCommand(sql, connection);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);

        while (await reader.ReadAsync(cancellationToken))
        {
            payments.Add(new PaymentSummary(
                reader.GetInt32(0),
                reader.GetString(1),
                reader.GetDateTime(2),
                reader.GetDecimal(3),
                reader.GetString(4),
                reader.GetString(5),
                reader.GetString(6)));
        }

        return payments;
    }

    public async Task<IReadOnlyList<TrainerRevenueSummary>> GetTrainerRevenueAsync(
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                TrainerID,
                CONCAT(TrainerFirstName, ' ', TrainerLastName) AS TrainerName,
                Specialization,
                CompletedSessions,
                TotalSessionHours,
                TotalRevenue
            FROM vw_TrainerRevenue
            ORDER BY TotalRevenue DESC, TrainerLastName, TrainerFirstName;
            """;

        var revenue = new List<TrainerRevenueSummary>();
        await using var connection = await OpenConnectionAsync(cancellationToken);
        await using var command = new SqlCommand(sql, connection);
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);

        while (await reader.ReadAsync(cancellationToken))
        {
            revenue.Add(new TrainerRevenueSummary(
                reader.GetInt32(0),
                reader.GetString(1),
                reader.GetString(2),
                reader.GetInt32(3),
                reader.GetDecimal(4),
                reader.GetDecimal(5)));
        }

        return revenue;
    }

    private async Task<SqlConnection> OpenConnectionAsync(
        CancellationToken cancellationToken)
    {
        var connection = new SqlConnection(_connectionString);

        try
        {
            await connection.OpenAsync(cancellationToken);
            return connection;
        }
        catch
        {
            await connection.DisposeAsync();
            throw;
        }
    }
}
