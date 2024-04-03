import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/app_bar.dart';
import 'package:utibu_health_app/pages/forms/new_medication.dart';
import 'package:utibu_health_app/pages/forms/new_prescription.dart';
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
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.medical_services),
                        title: const Text('New Medication'),
                        subtitle: const Text('Add a new drug to your inventory'),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewMedicationPage()),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.medical_services),
                        title: const Text('New Prescription'),
                        subtitle: const Text('Create a new prescription on behalf of a patient'),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewPrescriptionPage()),
                          );
                        },
                      ),
                    ],
                  ),
                );
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
