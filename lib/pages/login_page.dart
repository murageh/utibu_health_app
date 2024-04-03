import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/inputs.dart';
import 'package:utibu_health_app/pages/home/patient.dart';
import 'package:utibu_health_app/pages/home/pharmacist.dart';
import 'package:utibu_health_app/pages/register_page.dart';
import 'package:utibu_health_app/providers/identity/Identityprovider.dart';
import 'package:utibu_health_app/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IdentityProvider>(
          builder: (context, identityProvider, child) {
        if (kDebugMode) {
          print('IdentityProvider (login): ${identityProvider.user?.toJSON()}');
        }
        if (identityProvider.isLoggedIn) {
          var role = identityProvider.role;
          if (role == 'pharmacist') {
            return const PharmacistHomePage();
          } else {
            return const PatientHomePage();
          }
        }

        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Utibu Health",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Welcome back. Please login to continue.",
                    ),
                    const SizedBox(height: 16),
                    RoundedTextField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Email",
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                    RoundedTextField(
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
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: _isLoggingIn
                          ? const Center(child: CircularProgressIndicator())
                          : SubtlyRoundedElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoggingIn = true;
                                  });
                                  var user = await ApiService().login(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                  setState(() {
                                    _isLoggingIn = false;
                                  });
                                  if (user != null) {
                                    if (kDebugMode) {
                                      print(user);
                                    }
                                    identityProvider.updateIdentityUser(user);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Invalid email or password"),
                                        backgroundColor: Colors.red,
                                        showCloseIcon: true,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text("Login"),
                            ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text("Don't have an account? Register"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
