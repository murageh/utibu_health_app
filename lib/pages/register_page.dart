import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:utibu_health_app/pages/login_page.dart';

import '../models/user.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isRegistering = false;

  // fields: first_name, last_name, username, password, phone_number
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your first name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "First Name",
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                TextFormField(
                  controller: lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your last name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Last Name",
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                TextFormField(
                  controller: usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your username";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Username",
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Password",
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  obscureText: true,
                ),
                TextFormField(
                  controller: phoneNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your phone number";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _isRegistering
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              setState(() {
                                _isRegistering = true;
                              });
                              bool registered = await ApiService().register(
                                User(
                                  null,
                                  userId: 0,
                                  username: usernameController.text,
                                  password: passwordController.text,
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  phoneNumber: phoneNumberController.text,
                                ),
                              );
                              setState(() {
                                _isRegistering = false;
                              });
                              if (registered) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Registration successful, please login."),
                                    backgroundColor: Colors.green,
                                    showCloseIcon: true,
                                  ),
                                );
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Registration failed"),
                                    backgroundColor: Colors.red,
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text("Register"),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
