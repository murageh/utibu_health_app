import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/app_bar.dart';
import 'package:utibu_health_app/pages/login_page.dart';
import 'package:utibu_health_app/providers/identity/Identityprovider.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  _PatientHomePageState createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  final title = 'Utibu Health';

  @override
  Widget build(BuildContext context) {
    return Consumer<IdentityProvider>(
        builder: (context, identityProvider, child) {
      if (!identityProvider.isLoggedIn) {
        return const LoginPage();
      }
      return Scaffold(
        appBar: buildAppBar(
          context,
          title,
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: const Text('Order History'),
                onTap: () {
                  // Navigate to the order history page
                },
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                  // Navigate to the profile page
                },
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Handle order submission or other functionality
          },
          tooltip: 'Place Order',
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
