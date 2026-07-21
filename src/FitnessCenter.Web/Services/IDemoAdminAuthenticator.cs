namespace FitnessCenter.Web.Services;

public enum DemoAuthenticationResult
{
    Success,
    InvalidCredentials,
    NotConfigured
}

public interface IDemoAdminAuthenticator
{
    DemoAuthenticationResult Validate(string username, string password);
}
