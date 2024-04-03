import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/pages/login_page.dart';
import 'package:utibu_health_app/providers/identity/Identityprovider.dart';

AppBar buildAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
    backgroundColor: Theme.of(context).primaryColor,
    foregroundColor: Colors.white,
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Logout"),
                content: const Text("Are you sure you want to logout?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      // Close the dialog
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      IdentityProvider provider = Provider.of<IdentityProvider>(context, listen: false);
                      provider.logout();
                      Navigator.of(context).pop();
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                    child: const Text("Logout"),
                  ),
                ],
              );
            },
          );
        },
      ),
    ],
  );
}
