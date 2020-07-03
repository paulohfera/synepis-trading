using System.Collections.Generic;

namespace Synepis.Trading.Api.Core.ValueObjects
{
	public class ResultValueObject
	{
		public bool Sucess { get; set; }
		public IList<string> Messages { get; set; }
		public object Body { get; set; }

		public ResultValueObject(bool sucess)
		{
			Sucess = sucess;
		}

		public ResultValueObject(bool sucess, string message)
		{
			Sucess = sucess;
			AddMessage(message);
		}

		public ResultValueObject(bool sucess, IList<string> messages)
		{
			Sucess = sucess;
			Messages = messages;
		}

		public ResultValueObject(bool sucess, IList<string> messages, object body)
		{
			Sucess = sucess;
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
