import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants.dart';

class Logout {
  final SharedPreferences sharedPreferences;

  Logout(this.sharedPreferences);

  Future<bool> call(String teste) async {
    return await sharedPreferences.remove(CACHED_USER);
  }
}
