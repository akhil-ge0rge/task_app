import 'package:shared_preferences/shared_preferences.dart';

class SpServices {
  Future<void> setToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('x-auth-token');
  }
}
