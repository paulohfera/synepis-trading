namespace Synepis.Trading.Api.Account.Models
{
	public class ResetPasswordConfirmViewModel
	{
		public string Email { get; set; }
		public string Password { get; set; }
		public string ConfirmationCode { get; set; }
	}
}
