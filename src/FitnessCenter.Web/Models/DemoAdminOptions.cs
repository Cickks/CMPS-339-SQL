namespace FitnessCenter.Web.Models;

public sealed class DemoAdminOptions
{
    public const string SectionName = "DemoAdmin";

    public string Username { get; init; } = "admin@fitness.demo";

    public string? Password { get; init; }
}
