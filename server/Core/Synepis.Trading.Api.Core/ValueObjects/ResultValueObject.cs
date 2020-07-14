using System.Collections.Generic;

namespace Synepis.Trading.Api.Core.ValueObjects
{
	public class ResultValueObject
	{
		public bool Success { get; set; }
		public IList<string> Messages { get; set; }
		public object Body { get; set; }

		public ResultValueObject(bool success)
		{
			Success = success;
		}

		public ResultValueObject(bool success, string message)
		{
			Success = success;
			AddMessage(message);
		}

		public ResultValueObject(bool success, IList<string> messages)
		{
			Success = success;
			Messages = messages;
		}

		public ResultValueObject(bool success, IList<string> messages, object body)
		{
			Success = success;
			Messages = messages;
			Body = body;
		}

		public void AddMessage(string message)
		{
			if (Messages == null) Messages = new List<string>();
			Messages.Add(message);
		}
	}
}
