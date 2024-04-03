import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:utibu_health_app/models/medication.dart';
import 'package:utibu_health_app/models/order.dart';
import 'package:utibu_health_app/models/prescription.dart';

import '../models/user.dart';

class ApiService {
  final _baseUrl = 'http://10.0.2.2:3000/api'; // localhost

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/login'),
      body: json.encode({
        'username': email,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (kDebugMode) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      User user = User.fromJSON(jsonBody['user']);
      user.setToken(jsonBody['token']);
      return user;
    }

    return null;
  }

  Future<bool> register(User user) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/register'),
      body: json.encode(user.toJSON()),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (kDebugMode) {
      print(response.body);
    }

    return response.statusCode == 201;
  }

  Future<bool> logout(String token) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }

  // USERS API
  Future<List<User>> getUsers(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      // print(response.body);
    }

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> userList = jsonBody['user'];
      if (kDebugMode) {
        print(userList);
      }
      var users = <User>[];
      for (var user in userList) {
        users.add(User.fromJSON(user));
      }
      return users;
    }

    return List<User>.empty();
  }

  // ORDERS
  Future<List<Order>> getOrders(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/orders'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> list = jsonBody['data'];
      var orders = <Order>[];
      for (var order in list) {
        orders.add(Order.fromJSON(order));
      }
      return orders;
    }

    return List<Order>.empty();
  }

  // MEDICATION

  Future<List<Medication>> getMedications(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/medication'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      print('getMedication: ${response.body}'); // 'getMedications: []'
    }

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> list = jsonBody['data'];
      var medications = <Medication>[];
      for (var medication in list) {
        medications.add(Medication.fromJSON(medication));
      }
      return medications;
    }

    return List<Medication>.empty();
  }

  Future<bool> createMedication(Medication medication, String? token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/medication'),
        body: json.encode(medication.toJSON()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        print('createMedication: ${response.body}'); // 'createMedication: {}'
      }

      return response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        print('createMedication error: $e');
      }
      return false;
    }
  }

  Future<bool> updateMedication(Medication medication, String? token) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/medication/${medication.medicationId}'),
      body: json.encode(medication.toJSON()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }

  Future<bool> updateStock(int medicationId, int newStockLevel, String? token) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/medication/$medicationId/stock'),
      body: json.encode({
        'stock_level': newStockLevel,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if(kDebugMode) {
      print('updateStock: token $token');
      print('updateStock: ${response.request}');
      print('updateStock: ${response.body}');
    }

    return response.statusCode == 200;
  }

  // PRESCRIPTIONS
  Future<List<Prescription>> getPrescriptions(String? token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/prescriptions'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      print('getPrescriptions: ${response.body}'); // 'getPrescriptions: []'
    }

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List<dynamic> list = jsonBody['data'];
      var prescriptions = <Prescription>[];
      for (var prescription in list) {
        prescriptions.add(Prescription.fromJSON(prescription));
      }
      return prescriptions;
    }

    return List<Prescription>.empty();
  }

  Future<bool> createPrescription(NewPrescription prescription, String? token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/prescriptions'),
        body: json.encode(prescription.toJSON()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        print('createPrescription: ${response.request}'); // 'createPrescription: {}'
        print('createPrescription: ${response.body}'); // 'createPrescription: {}'
      }

      return response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        print('createPrescription error: $e');
      }
      return false;
    }
  }
}
