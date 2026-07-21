using System.ComponentModel.DataAnnotations;

namespace FitnessCenter.Web.Models;

public sealed class LoginViewModel
{
    [Required]
    [Display(Name = "Demo admin email")]
    public string Username { get; set; } = string.Empty;

    [Required]
    [DataType(DataType.Password)]
    public string Password { get; set; } = string.Empty;

    public string? ReturnUrl { get; set; }
}
