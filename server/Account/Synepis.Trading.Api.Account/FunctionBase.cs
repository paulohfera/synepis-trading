using Amazon.Lambda.APIGatewayEvents;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System.Collections.Generic;
using System.Net;

namespace Synepis.Trading.Api.Account
{
	public class FunctionBase
	{
		public APIGatewayProxyResponse Ok(object response)
		{
			return Respose(HttpStatusCode.OK, response);
		}

		public APIGatewayProxyResponse BadRequest(object response)
		{
			return Respose(HttpStatusCode.BadRequest, response);
		}

		public APIGatewayProxyResponse Respose(HttpStatusCode statusCode, object response)
		{
			var serializerSettings = new JsonSerializerSettings { ContractResolver = new CamelCasePropertyNamesContractResolver() };
			return new APIGatewayProxyResponse
			{
				StatusCode = (int)statusCode,
				Body = JsonConvert.SerializeObject(response, serializerSettings),
				Headers = new Dictionary<string, string> { { "Content-Type", "application/json" } }
			};
		}
	}
}
