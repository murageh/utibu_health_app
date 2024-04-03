import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/app_bar.dart';
import 'package:utibu_health_app/models/user.dart';
import 'package:utibu_health_app/pages/lists/view_list.dart';
import 'package:utibu_health_app/pages/login_page.dart';
import 'package:utibu_health_app/providers/identity/Identityprovider.dart';
import 'package:utibu_health_app/services/api_service.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> users = [];

  void getUsers(String? token) async {
    await ApiService().getUsers(token).then((value) {
      setState(() {
        users = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    IdentityProvider identityProvider =
        Provider.of<IdentityProvider>(context, listen: false);
    getUsers(identityProvider.identity?['token']);
  }

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
          'Users',
        ),
        body: ViewList(
          title: 'Users',
          items: users
              .map((user) => Item(
                  title: '${user.name}',
                  subtitle: '${user.phoneNumber} - ${user.role}',
                  backgroundColor: user.role == 'pharmacist'
                      ? Colors.green.shade100
                      : user.role == 'patient'
                          ? Colors.blue.shade100
                          : Colors.grey.shade100,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('User Details'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Name: ${user.name}'),
                              Text('username: ${user.username}'),
                              Text('Email: ${user.username}'),
                              Text('Phone Number: ${user.phoneNumber}'),
                              Text('Role: ${user.role.toUpperCase()}'),
                            ],
                          ),
                          alignment: Alignment.center,
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  }))
              .toList(),
        ),
      );
    });
  }
}
