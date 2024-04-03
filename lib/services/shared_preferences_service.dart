import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class SharedPreferencesService {
  static Future<SharedPreferencesService> init() async {
    final instance = SharedPreferencesService._();
    await instance.load();
    return instance;
  }

  SharedPreferencesService._();

  late SharedPreferences _preferences;

  Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveUser(User user) async {
    await _preferences.setString('user', user.toJSON());
  }

  User? getUser() {
    final json = _preferences.getString('user');

    if (json == null) {
      return null;
    }

    return User.fromJSON(jsonDecode(json));
  }

  Future<void> removeUser() async {
    await _preferences.remove('user');
  }
}