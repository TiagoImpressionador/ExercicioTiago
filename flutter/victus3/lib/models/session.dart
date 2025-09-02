import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Map<String, dynamic>? user;

  static Future<void> saveUser(Map<String, dynamic> u) async {
    user = u;
    final sp = await SharedPreferences.getInstance();
    await sp.setString('user', jsonEncode(u));
  }

  static Future<void> loadUser() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString('user');
    if (s != null) user = jsonDecode(s);
  }

  static Future<void> clear() async {
    user = null;
    final sp = await SharedPreferences.getInstance();
    await sp.remove('user');
  }
}
