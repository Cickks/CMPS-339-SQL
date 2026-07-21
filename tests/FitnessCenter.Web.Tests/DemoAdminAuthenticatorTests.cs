using FitnessCenter.Web.Models;
using FitnessCenter.Web.Services;
using Microsoft.Extensions.Options;

namespace FitnessCenter.Web.Tests;

public sealed class DemoAdminAuthenticatorTests
{
    [Fact]
    public void Validate_ReturnsSuccess_ForConfiguredCredentials()
    {
        var authenticator = CreateAuthenticator("demo-password");

        var result = authenticator.Validate(
            "ADMIN@FITNESS.DEMO",
            "demo-password");

        Assert.Equal(DemoAuthenticationResult.Success, result);
    }

    [Fact]
    public void Validate_ReturnsInvalidCredentials_ForWrongPassword()
    {
        var authenticator = CreateAuthenticator("demo-password");

        var result = authenticator.Validate(
            "admin@fitness.demo",
            "wrong-password");

        Assert.Equal(DemoAuthenticationResult.InvalidCredentials, result);
    }

    [Fact]
    public void Validate_ReturnsNotConfigured_WhenPasswordIsMissing()
    {
        var authenticator = CreateAuthenticator(null);

        var result = authenticator.Validate(
            "admin@fitness.demo",
            "anything");

        Assert.Equal(DemoAuthenticationResult.NotConfigured, result);
    }

    private static DemoAdminAuthenticator CreateAuthenticator(string? password)
    {
        return new DemoAdminAuthenticator(
            Options.Create(new DemoAdminOptions
            {
                Username = "admin@fitness.demo",
                Password = password
            }));
    }
}
