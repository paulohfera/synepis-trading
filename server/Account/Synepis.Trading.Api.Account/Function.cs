using Account.Models;
using Amazon;
using Amazon.CognitoIdentityProvider;
using Amazon.CognitoIdentityProvider.Model;
using Amazon.Extensions.CognitoAuthentication;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Amazon.Runtime;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Synepis.Trading.Api.Account.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]
namespace Synepis.Trading.Api.Account
{
	public class Function : FunctionBase
	{
		public static IConfigurationRoot Configuration { get; set; }
		public static AppSettings appSettings { get; set; }

		public Function()
		{
			var builder = new ConfigurationBuilder()
				.SetBasePath(Directory.GetCurrentDirectory())
				.AddJsonFile("appsettings.json", false, true);

			var config = builder.Build();

			appSettings = config.GetSection("AppSettings").Get<AppSettings>();
		}

		public async Task<APIGatewayProxyResponse> Register(APIGatewayProxyRequest request)
		{
			try
			{
				var viewModel = JsonConvert.DeserializeObject<RegisterViewModel>(request.Body);

				var provider = new AmazonCognitoIdentityProviderClient(appSettings.AwsAccessKeyId, appSettings.AwsSecretAccessKey, RegionEndpoint.GetBySystemName(appSettings.AwsRegion));
				var signup = new SignUpRequest { ClientId = appSettings.AwsAppClientId, Username = viewModel.Email, Password = viewModel.Password };
				var atributes = new List<AttributeType> {
					new AttributeType { Name = "name", Value = viewModel.Name },
					new AttributeType { Name = "email", Value = viewModel.Email },
				};
				signup.UserAttributes = atributes;

				var result = await provider.SignUpAsync(signup);

				var addUserToGroupRequest = new AdminAddUserToGroupRequest { GroupName = "Free", UserPoolId = appSettings.AwsPoolId, Username = viewModel.Email };
				var groupResult = await provider.AdminAddUserToGroupAsync(addUserToGroupRequest);

				return Ok(new { Result = result, GroupResult = groupResult });
			}
			catch (UsernameExistsException)
			{
				return Ok("O usuário já existe.");
			}
			catch (Exception e)
			{
				return BadRequest(e.Message);
			}
		}

		public async Task<APIGatewayProxyResponse> Login(APIGatewayProxyRequest request)
		{
			try
			{
				var viewModel = JsonConvert.DeserializeObject<LoginViewModel>(request.Body);

				var provider = new AmazonCognitoIdentityProviderClient(new AnonymousAWSCredentials(), RegionEndpoint.GetBySystemName(appSettings.AwsRegion));
				var userPool = new CognitoUserPool(appSettings.AwsPoolId, appSettings.AwsAppClientId, provider);
				var user = new CognitoUser(viewModel.Email, appSettings.AwsAppClientId, userPool, provider);

				var authRequest = new InitiateSrpAuthRequest { Password = viewModel.Password };
				var response = await user.StartWithSrpAuthAsync(authRequest);

				var getUserRequest = new GetUserRequest
				{
					AccessToken = response.AuthenticationResult.AccessToken
				};

				return Ok(response);
			}
			catch (Exception e)
			{
				return BadRequest(e.Message);
			}
		}

		public async Task<APIGatewayProxyResponse> ChangePassword(APIGatewayProxyRequest request)
		{
			try
			{
				var viewModel = JsonConvert.DeserializeObject<ChangePasswordViewModel>(request.Body);

				var provider = new AmazonCognitoIdentityProviderClient(new AnonymousAWSCredentials(), RegionEndpoint.GetBySystemName(appSettings.AwsRegion));
				var userPool = new CognitoUserPool(appSettings.AwsPoolId, appSettings.AwsAppClientId, provider);
				var user = new CognitoUser(viewModel.Email, appSettings.AwsAppClientId, userPool, provider);

				var authRequest = new InitiateSrpAuthRequest { Password = viewModel.CurrentPassword };
				var authResponse = await user.StartWithSrpAuthAsync(authRequest);

				var changePasswordRequest = new ChangePasswordRequest
				{
					AccessToken = authResponse.AuthenticationResult.AccessToken,
					PreviousPassword = viewModel.CurrentPassword,
					ProposedPassword = viewModel.NewPassword
				};
				var changePasswordResponse = await provider.ChangePasswordAsync(changePasswordRequest);

				return Ok(changePasswordResponse);
			}
			catch (Exception e)
			{
				return BadRequest(e.Message);
			}
		}

		public async Task<APIGatewayProxyResponse> ResetPassword(APIGatewayProxyRequest request)
		{
			try
			{
				var viewModel = JsonConvert.DeserializeObject<ChangePasswordViewModel>(request.Body);

				var provider = new AmazonCognitoIdentityProviderClient(appSettings.AwsAccessKeyId, appSettings.AwsSecretAccessKey, RegionEndpoint.GetBySystemName(appSettings.AwsRegion));
				var passworRequest = new AdminResetUserPasswordRequest { Username = viewModel.Email, UserPoolId = appSettings.AwsPoolId };

				var response = await provider.AdminResetUserPasswordAsync(passworRequest);

				return Ok(response);
			}
			catch (Exception e)
			{
				return BadRequest(e.Message);
			}
		}

		public async Task<APIGatewayProxyResponse> ResetPasswordConfirm(APIGatewayProxyRequest request)
		{
			try
			{
				var viewModel = JsonConvert.DeserializeObject<ResetPasswordConfirmViewModel>(request.Body);

				var provider = new AmazonCognitoIdentityProviderClient(appSettings.AwsAccessKeyId, appSettings.AwsSecretAccessKey, RegionEndpoint.GetBySystemName(appSettings.AwsRegion));
				var passworRequest = new ConfirmForgotPasswordRequest
				{
					ClientId = appSettings.AwsAppClientId,
					ConfirmationCode = viewModel.ConfirmationCode,
					Password = viewModel.Password,
					Username = viewModel.Email
				};

				var response = await provider.ConfirmForgotPasswordAsync(passworRequest);

				return Ok(response);
			}
			catch (Exception e)
			{
				return BadRequest(e.Message);
			}
		}

	}
}
