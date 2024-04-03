import 'package:flutter/material.dart';
import 'package:utibu_health_app/components/inputs.dart';
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 96.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 32.0),
                      child: Image.asset(
                        'assets/images/icon.png',
                        width: 180,
                      ),
                    ),
                  ),
                  const Text(
                    "Utibu Health",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Thank you for choosing Utibu Health. Please register to continue.",
                  ),
                  const SizedBox(height: 16),
                  RoundedTextField(
                    controller: firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your first name";
                      }
                      return null;
                    },
                    hintText: "First Name",
                  ),
                  RoundedTextField(
                    controller: lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your last name";
                      }
                      return null;
                    },
                    hintText: "Last Name",
                  ),
                  RoundedTextField(
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      }
                      return null;
                    },
                    hintText: "Username",
                  ),
                  RoundedTextField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                    hintText: "Password",
                    obscureText: true,
                  ),
                  RoundedTextField(
                    controller: phoneNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your phone number";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    hintText: "Phone Number",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _isRegistering
                        ? const Center(child: CircularProgressIndicator())
                        : SubtlyRoundedElevatedButton(
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
                                          builder: (context) =>
                                              const LoginPage()));
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
                  const SizedBox(height: 0.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text("Already have an account? Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
