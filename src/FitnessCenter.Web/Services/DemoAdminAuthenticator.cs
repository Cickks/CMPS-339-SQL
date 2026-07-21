using System.Security.Cryptography;
using System.Text;
using FitnessCenter.Web.Models;
using Microsoft.Extensions.Options;

namespace FitnessCenter.Web.Services;

public sealed class DemoAdminAuthenticator(
    IOptions<DemoAdminOptions> options) : IDemoAdminAuthenticator
{
    private readonly DemoAdminOptions _options = options.Value;

    public DemoAuthenticationResult Validate(string username, string password)
    {
        if (string.IsNullOrWhiteSpace(_options.Password))
        {
            return DemoAuthenticationResult.NotConfigured;
        }

        var usernameMatches = FixedTimeEquals(
            username.Trim().ToUpperInvariant(),
            _options.Username.Trim().ToUpperInvariant());
        var passwordMatches = FixedTimeEquals(password, _options.Password);

        return usernameMatches && passwordMatches
            ? DemoAuthenticationResult.Success
            : DemoAuthenticationResult.InvalidCredentials;
    }

    private static bool FixedTimeEquals(string provided, string expected)
    {
        var providedHash = SHA256.HashData(Encoding.UTF8.GetBytes(provided));
        var expectedHash = SHA256.HashData(Encoding.UTF8.GetBytes(expected));
        return CryptographicOperations.FixedTimeEquals(providedHash, expectedHash);
    }
}
