class LoggedUser {
  String email;
  String name;
  String token;

  LoggedUser({this.email, this.name, this.token});

  LoggedUser.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    email = json['email'];
    name = json['name'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['token'] = this.token;
    return data;
  }
}
