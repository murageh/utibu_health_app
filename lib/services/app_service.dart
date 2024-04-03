import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'api_service.dart';
import 'shared_preferences_service.dart';

class AppService {
  final _api = ApiService();
  final _sharedPreferencesService = SharedPreferencesService.init();

  Future<void> login(User user) async {
    final response = await _api.login(
      user.username,
      user.password,
    );

    if (response != null) {
      (await _sharedPreferencesService).saveUser(response);
    }
  }

  Future<void> logout() async {
    final success = await _api.logout((await _sharedPreferencesService).getUser()?.token ?? '');

    if (success) {
      (await _sharedPreferencesService).removeUser();
    }
  }

  Future<User?> getUser() async {
    return (await _sharedPreferencesService).getUser();
  }
}