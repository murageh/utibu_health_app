import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utibu_health_app/models/user.dart';

class IdentityProvider extends ChangeNotifier {
  IdentityProvider() {
    _loadIdentity();
  }

  Map<String, dynamic>? _identity;

  Map<String, dynamic>? get identity => _identity;

  void _loadIdentity() async {
    final prefs = await SharedPreferences.getInstance();
    final identity = prefs.getString('identity');
    if (identity != null) {
      _identity = jsonDecode(identity);
    } else {
      // add must-have fields
      _identity = {};
      prefs.setString('identity', jsonEncode(_identity));
    }

    notifyListeners();
  }

  get isLoggedIn =>
      _identity != null &&
      _identity!['user'] != null &&
      _identity!['token'] != null;

  String? get role => _identity != null && _identity!['user'] != null ? _identity!['user']['role'] : null;

  User? get user => _identity != null && _identity!['user'] != null ? User.fromJSON(_identity!['user']) : null;

  void setIdentity(Map<String, dynamic> identity) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('identity', jsonEncode(identity));
    _identity = identity;
    notifyListeners();
  }

  void clearIdentity() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('identity');
    _identity = null;
    notifyListeners();
  }

  void updateIdentity(Map<String, dynamic> identity) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('identity', jsonEncode(identity));
    _identity = identity;
    notifyListeners();
  }

  void updateIdentityToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    final identity = prefs.getString('identity');
    if (identity != null) {
      final identityMap = jsonDecode(identity);
      identityMap['token'] = token;
      prefs.setString('identity', jsonEncode(identityMap));
      _identity = identityMap;
      notifyListeners();
    }
  }

  void updateIdentityUser(User? user) async {
    final prefs = await SharedPreferences.getInstance();
    final identity = prefs.getString('identity');
    if (identity != null) {
      final identityMap = jsonDecode(identity);
      identityMap['user'] = user?.toJSON();
      identityMap['token'] = user?.token;
      prefs.setString('identity', jsonEncode(identityMap));
      _identity = identityMap;
      notifyListeners();
    } else {
      final identityMap = {
        'user': user?.toJSON(),
        'token': user?.token,
      };
      prefs.setString('identity', jsonEncode(identityMap));
      _identity = identityMap;
      notifyListeners();
    }
  }

  void updateIdentityUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    final identity = prefs.getString('identity');
    if (identity != null) {
      final identityMap = jsonDecode(identity);
      identityMap['user']['phone_number'] = phone;
      prefs.setString('identity', jsonEncode(identityMap));
      _identity = identityMap;
      notifyListeners();
    }
  }

  void logout() {
    clearIdentity();
  }
}