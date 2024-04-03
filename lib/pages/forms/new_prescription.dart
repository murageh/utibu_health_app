import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/app_bar.dart';
import 'package:utibu_health_app/components/inputs.dart';
import 'package:utibu_health_app/models/medication.dart';
import 'package:utibu_health_app/models/prescription.dart';
import 'package:utibu_health_app/models/user.dart';
import 'package:utibu_health_app/pages/login_page.dart';
import 'package:utibu_health_app/providers/identity/Identityprovider.dart';
import 'package:utibu_health_app/services/api_service.dart';

class NewPrescriptionPage extends StatefulWidget {
  const NewPrescriptionPage({super.key});

  @override
  State<NewPrescriptionPage> createState() => _NewPrescriptionPageState();
}

class _NewPrescriptionPageState extends State<NewPrescriptionPage> {
  final String title = 'New prescription';
  final _formKey = GlobalKey<FormState>();
  bool _isCreating = false;
  final List<User> users = [];
  final List<Medication> medications = [];
  bool _shouldChooseUser = false;

  Medication? _selectedMedication;

  // fields: userId, medicationId, doctorName, prescriptionDate, quantity, dosage, refillCount
  TextEditingController userIdController = TextEditingController();
  TextEditingController medicationIdController = TextEditingController();
  TextEditingController doctorNameController = TextEditingController();
  TextEditingController prescriptionDateController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController refillCountController = TextEditingController();
  TextEditingController quantityCountController = TextEditingController();

  void getMedications(String? token) async {
    await ApiService().getMedications(token).then((value) {
      medications.clear();
      setState(() {
        medications.addAll(value);
      });
    });
  }

  void getUsers(String? token) async {
    await ApiService().getUsers(token).then((value) {
      users.clear();
      setState(() {
        users.addAll(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    IdentityProvider identityProvider =
        Provider.of<IdentityProvider>(context, listen: false);
    if (identityProvider.role == 'pharmacist') {
      _shouldChooseUser = true;
    }
    getMedications(identityProvider.identity?['token']);
    getUsers(identityProvider.identity?['token']);
  }

  void createPrescription(String? token) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isCreating = true;
      });
      await ApiService()
          .createPrescription(
        NewPrescription(
          userId: _shouldChooseUser
              ? int.tryParse(userIdController.text) ?? -1
              : Provider.of<IdentityProvider>(context, listen: false)
                      .user
                      ?.userId ??
                  -1,
          medicationId: int.tryParse(medicationIdController.text) ?? -1,
          doctorName: doctorNameController.text,
          prescriptionDate: prescriptionDateController.text,
          dosage: dosageController.text,
          refillCount: int.tryParse(refillCountController.text) ?? -1,
          quantity: int.tryParse(quantityCountController.text) ?? -1,
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
                  if (_shouldChooseUser)
                    RoundedDropdownButtonFormField<User>(
                      value: null,
                      items: users
                          .map((user) => DropdownMenuItem(
                                value: user,
                                child: Text(user.name),
                              ))
                          .toList(),
                      onChanged: (User? value) {
                        userIdController.text = value != null
                            ? value.userId.toString()
                            : userIdController.text;
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a user';
                        }
                        return null;
                      },
                      hintText: "Select user",
                    )
                  else
                    Container(),
                  RoundedDropdownButtonFormField<Medication>(
                    value: _selectedMedication,
                    items: medications
                        .map((medication) => DropdownMenuItem(
                              value: medication,
                              child: Text(medication.name),
                            ))
                        .toList(),
                    onChanged: (Medication? value) {
                      setState(() {
                        _selectedMedication = value;
                      });
                      medicationIdController.text = value != null
                          ? value.medicationId.toString()
                          : medicationIdController.text;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a medication';
                      }
                      return null;
                    },
                    hintText: "Select medication",
                  ),
                  RoundedTextField(
                    controller: doctorNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the doctor name";
                      }
                      return null;
                    },
                    hintText: 'Prescribing Doctor\'s Name',
                    helperText: "e.g. Dr. John Doe",
                  ),
                  RoundedTextField(
                    controller: prescriptionDateController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the prescription date";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Prescription Date",
                      helperText: "Click the calendar icon to select a date",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            ).then((value) {
                              prescriptionDateController.text = value != null
                                  ? value.toIso8601String()
                                  : prescriptionDateController.text;
                            });
                          },
                          icon: const Icon(Icons.calendar_today)),
                    ),
                  ),
                  RoundedTextField(
                    controller: quantityCountController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the quantity";
                      }
                      return null;
                    },
                    hintText:
                        "How many ${_selectedMedication?.unit != null ? "${_selectedMedication?.unit}(s)" : "units"}",
                    helperText: _selectedMedication == null
                        ? "Please select a medication"
                        : "${_selectedMedication?.name} is measured in ${_selectedMedication?.unit}(s)",
                  ),
                  RoundedTextField(
                    controller: dosageController,
                    minLines: 3,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the dosage";
                      }
                      return null;
                    },
                    hintText: "Dosage",
                    helperText: "e.g. 1 pill every 6 hours",
                  ),
                  RoundedTextField(
                    controller: refillCountController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the refill count";
                      }
                      return null;
                    },
                    hintText: "Refill Count",
                    helperText: "e.g. 3",
                  ),
                  const SizedBox(height: 16),
                  SubtlyRoundedElevatedButton(
                    onPressed: () {
                      createPrescription(identityProvider.identity?['token']);
                    },
                    child: _isCreating
                        ? const CircularProgressIndicator()
                        : const Text("Create prescription"),
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
