import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/app_bar.dart';
import 'package:utibu_health_app/pages/home/modal_sheet.dart';
import 'package:utibu_health_app/pages/lists/order_list.dart';
import 'package:utibu_health_app/pages/lists/prescription_list.dart';
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
                title: const Text('My Prescriptions'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrescriptionList()),
                  );
                },
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
              ListTile(
                title: const Text('My Order History'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderList()),
                  );
                },
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return modalSheetContent(context, userItems(context));
              },
            );
          },
          tooltip: 'Place Order',
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
