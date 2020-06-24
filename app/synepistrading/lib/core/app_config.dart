import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String apiAccount;
  final String apiForex;

  AppConfig({this.apiAccount, this.apiForex});

  static Future<AppConfig> getConfig() async {
    String contents = await rootBundle.loadString("assets/config/config.json");

    final json = jsonDecode(contents);

    return AppConfig(
      apiAccount: json["apiAccount"],
      apiForex: json["apiForex"],
    );
  }
}
