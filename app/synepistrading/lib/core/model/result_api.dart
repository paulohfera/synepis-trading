class ResultApi {
  bool sucess;
  List<String> messages;
  dynamic body;

  ResultApi(this.sucess, this.messages, this.body);

  ResultApi.fromJson(Map<String, dynamic> json) {
    sucess = json['sucess'];
    messages = json['messages'] != null ? json['messages'].cast<String>() : null;
    body = json['body'];
  }
}
