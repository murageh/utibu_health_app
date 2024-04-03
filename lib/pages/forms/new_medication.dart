import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/app_bar.dart';
import 'package:utibu_health_app/components/inputs.dart';
import 'package:utibu_health_app/models/medication.dart';
import 'package:utibu_health_app/pages/login_page.dart';
import 'package:utibu_health_app/providers/identity/Identityprovider.dart';
import 'package:utibu_health_app/services/api_service.dart';

class UnitItem {
  final String unit;

  UnitItem(this.unit);
}

class NewMedicationPage extends StatefulWidget {
  const NewMedicationPage({super.key});

  @override
  State<NewMedicationPage> createState() => _NewMedicationPageState();
}

class _NewMedicationPageState extends State<NewMedicationPage> {
  final String title = 'New medication';
  final _formKey = GlobalKey<FormState>();
  bool _isCreating = false;
  List<UnitItem> units = [];

  // fields: name, description, stock_level, price, unit
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController stockLevelController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  getUnits(String? token) async {
    await ApiService().getMedicationUnits(token).then((value) {
      setState(() {
        units = value.map((unit) => UnitItem(unit)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    IdentityProvider identityProvider =
        Provider.of<IdentityProvider>(context, listen: false);
    getUnits(identityProvider.identity?['token']);
  }

  void createMedication(String? token) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isCreating = true;
      });
      await ApiService()
          .createMedication(
        Medication(
          medicationId: 0,
          name: nameController.text,
          description: descriptionController.text,
          unit: unitController.text,
          stockLevel: int.parse(stockLevelController.text),
          price: double.parse(priceController.text),
        ),
        token,
      )
          .then((bool success) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Medication created successfully"),
              backgroundColor: Colors.green,
              dismissDirection: DismissDirection.up,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 150,
                  left: 10,
                  right: 10),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to create medication"),
            ),
          );
        }
      });
      setState(() {
        _isCreating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IdentityProvider>(
        builder: (context, identityProvider, child) {
      if (!identityProvider.isLoggedIn) {
        return const LoginPage();
      }
      return Scaffold(
        appBar: buildAppBar(context, title),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  RoundedTextField(
                    controller: nameController,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the medication name";
                      }
                      return null;
                    },
                    hintText: "Name",
                  ),
                  RoundedTextField(
                    controller: descriptionController,
                    minLines: 3,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the medication description";
                      }
                      return null;
                    },
                    hintText: "Medication Description",
                  ),
                  RoundedDropdownButtonFormField<UnitItem>(
                    value: null,
                    items: units
                        .map(
                          (unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(unit.unit),
                          ),
                        )
                        .toList(),
                    onChanged: (UnitItem? value) {
                      unitController.text = value!.unit;
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select the medication unit";
                      }
                      return null;
                    },
                    hintText: "Unit",
                  ),
                  RoundedTextField(
                    controller: stockLevelController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the medication stock level";
                      }
                      return null;
                    },
                    hintText: "Stock Level",
                  ),
                  RoundedTextField(
                    controller: priceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the medication price";
                      }
                      return null;
                    },
                    hintText: "Price",
                  ),
                  const SizedBox(height: 16),
                  SubtlyRoundedElevatedButton(
                    onPressed: () {
                      createMedication(identityProvider.identity?['token']);
                    },
                    child: _isCreating
                        ? const CircularProgressIndicator()
                        : const Text("Create Medication"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
