import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/app_bar.dart';
import 'package:utibu_health_app/pages/home/modal_sheet.dart';
import 'package:utibu_health_app/pages/lists/medication_list.dart';
import 'package:utibu_health_app/pages/lists/order_list.dart';
import 'package:utibu_health_app/pages/lists/prescription_list.dart';
import 'package:utibu_health_app/pages/lists/user_list.dart';
import 'package:utibu_health_app/pages/login_page.dart';
import 'package:utibu_health_app/providers/identity/Identityprovider.dart';

class PharmacistHomePage extends StatelessWidget {
  const PharmacistHomePage({super.key});

  final title = 'Utibu Health Admin';

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
          showBackButton: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: const Text('Users'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserList()),
                  );
                },
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
              ListTile(
                title: const Text('Medication'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MedicationList()),
                  );
                },
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
              ListTile(
                title: const Text('Prescriptions'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrescriptionList()),
                  );
                },
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
              ListTile(
                title: const Text('Orders'),
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
            // show popup menu for new medication, new prescription, new user, new order
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return modalSheetContent(context, pharmacistItems(context));
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
