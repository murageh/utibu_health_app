import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/app_bar.dart';
import 'package:utibu_health_app/components/inputs.dart';
import 'package:utibu_health_app/models/medication.dart';
import 'package:utibu_health_app/models/order.dart';
import 'package:utibu_health_app/models/user.dart';
import 'package:utibu_health_app/pages/lists/view_list.dart';
import 'package:utibu_health_app/pages/login_page.dart';
import 'package:utibu_health_app/providers/identity/Identityprovider.dart';
import 'package:utibu_health_app/services/api_service.dart';

class MedicationList extends StatefulWidget {
  const MedicationList({super.key});

  @override
  State<MedicationList> createState() => _MedicationListState();
}

class _MedicationListState extends State<MedicationList> {
  String title = 'Medication';
  List<Medication> medications = [];

  void getMedications(String? token) async {
    await ApiService().getMedications(token).then((value) {
      setState(() {
        medications = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    IdentityProvider identityProvider =
        Provider.of<IdentityProvider>(context, listen: false);
    getMedications(identityProvider.identity?['token']);
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
          title,
        ),
        body: ViewList(
          title: title,
          items: medications
              .map((medication) => Item(
                  title: medication.name,
                  subtitle:
                  '${medication.description}: KES ${medication
                      .price}\nRemaining Stock: ${medication
                      .stockLevel} ${medication.unit}(s)',
                  backgroundColor: medication.stockLevel > 10
                      ? Colors.green.shade50
                      : medication.stockLevel > 5
                          ? Colors.orange.shade50
                          : Colors.red.shade50,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return medicationDetails(medication, context, token: identityProvider.identity?['token']);
                      },
                    );
                  }))
              .toList(),
        ),
      );
    });
  }

  AlertDialog medicationDetails(Medication medication, BuildContext context, {String? token}) {
    updateStock(int medicationId, int newStockLevel) async {
      await ApiService()
          .updateStock(medicationId, newStockLevel, token)
          .then((value) {
        setState(() {
          medication.setStockLevel(newStockLevel);
        });
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Stock updated successfully"),
            backgroundColor: Colors.green,
            dismissDirection: DismissDirection.up,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 150,
                left: 10,
                right: 10),
          ),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update stock"),
          ),
        );
      });
    }

    triggerUpdateStock(int newStockLevel) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update Stock'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Current Stock: ${medication.stockLevel}'),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'New Stock Level',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    newStockLevel = int.tryParse(value) ?? 0;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  updateStock(medication.medicationId, newStockLevel);
                  Navigator.of(context).pop();
                },
                child: const Text('Update'),
              ),
            ],
          );
        },
      );
    }

    return AlertDialog(
      title: const Text('Medication Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Name: ${medication.name}'),
          Text('Description: ${medication.description}'),
          Text('Price: KES ${medication.price}'),
          Text('Stock: ${medication.stockLevel}'),

          const SizedBox(height: 0.0,),
          // update stock button
          TextButton(
            onPressed: () {
              triggerUpdateStock(medication.stockLevel);
            },
            child: const Text('Update Stock'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
