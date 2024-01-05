import 'package:shared_preferences/shared_preferences.dart';

class StorageRepository {

    static Future<void> saveUserId(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', value);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<void> removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }

  static Future<void> saveAccessToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', value);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  static Future<void> saveRefreshToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', value);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  static Future<void> removeRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('refresh_token');
  }

  static Future<void> saveDeviceToken(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_token', value);
  }

  static Future<String?> getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('device_token');
  }

  static Future<void> savePhone(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', value);
  }

  static Future<String?> getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  static Future<void> removePhone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('phone');
  }

   static Future<void> savePassword(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', value);
  }

  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  static Future<void> removePassword() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('password');
  }

  static Future<void> saveIsRemember() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemember', true);
  }

  static Future<bool?> getIsRemember() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isRemember');
  }

  static Future<void> removeIsRemember() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isRemember');
  }

}