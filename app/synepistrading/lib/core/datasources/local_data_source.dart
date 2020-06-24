import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synepistrading/core/model/theme_setting.dart';

import '../constants.dart';
import '../model/logged_user.dart';

class LocalDataSource {
  static const String cur_theme = 'synepis_theme_pref';

  final SharedPreferences _sharedPreferences;

  LocalDataSource(this._sharedPreferences);

  Future<void> set(String key, value) async {
    if (value is bool) {
      _sharedPreferences.setBool(key, value);
    } else if (value is String) {
      _sharedPreferences.setString(key, value);
    } else if (value is double) {
      _sharedPreferences.setDouble(key, value);
    } else if (value is int) {
      _sharedPreferences.setInt(key, value);
    }
  }

  dynamic get(String key, {dynamic defaultValue}) {
    return _sharedPreferences.get(key) ?? defaultValue;
  }

  String getString(String key, {String defaultValue}) {
    return _sharedPreferences.getString(key) ?? defaultValue;
  }

  LoggedUser get user {
    var userJson = _sharedPreferences.get(CACHED_USER);
    if (userJson == null) {
      return null;
    }
    return LoggedUser.fromJson(json.decode(userJson));
  }

  ThemeSetting get theme {
    return ThemeSetting(ThemeOptions
        .values[get(cur_theme, defaultValue: ThemeOptions.DARK.index)]);
  }
}
