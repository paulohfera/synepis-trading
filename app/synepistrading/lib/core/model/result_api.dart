class ResultApi {
  bool success;
  List<String> messages;
  dynamic body;

  ResultApi(this.success, this.messages, this.body);

  ResultApi.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    messages = json['messages'] != null ? json['messages'].cast<String>() : null;
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "messages": messages,
      "body": body,
    };
  }
}
