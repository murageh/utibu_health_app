import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/app_bar.dart';
import 'package:utibu_health_app/components/inputs.dart';
import 'package:utibu_health_app/models/prescription.dart';
import 'package:utibu_health_app/models/user.dart';
import 'package:utibu_health_app/pages/login_page.dart';
import 'package:utibu_health_app/providers/identity/Identityprovider.dart';
import 'package:utibu_health_app/services/api_service.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  final String title = 'New Order';
  final _formKey = GlobalKey<FormState>();
  bool _isCreating = false;
  final List<User> users = [];
  final List<Prescription> prescriptions = [];
  bool _shouldChooseUser = false;

  // fields: userId, prescriptionId
  TextEditingController userIdController = TextEditingController();
  TextEditingController prescriptionIdController = TextEditingController();

  void getPrescriptions(String? token) async {
    await ApiService().getPrescriptions(token).then((value) {
      prescriptions.clear();
      setState(() {
        prescriptions.addAll(value);
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
    getPrescriptions(identityProvider.identity?['token']);
    getUsers(identityProvider.identity?['token']);
  }

  void createOrder(String? token) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isCreating = true;
      });
      int userId = _shouldChooseUser
          ? int.tryParse(userIdController.text) ?? 0
          : Provider.of<IdentityProvider>(context, listen: false)
                  .user
                  ?.userId ??
              -1;
      await ApiService()
          .createOrder(
              userId, int.tryParse(prescriptionIdController.text) ?? 0, token)
          .then((bool success) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Order created successfully"),
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
              content: Text("Failed to create order"),
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
                  RoundedDropdownButtonFormField<Prescription>(
                    value: null,
                    items: prescriptions
                        .map((prescription) => DropdownMenuItem(
                              value: prescription,
                              child: Text(
                                '${prescription.medication?.name} (${prescription.dosage}) on ${prescription.dateString}',
                              ),
                            ))
                        .toList(),
                    onChanged: (Prescription? value) {
                      prescriptionIdController.text = value != null
                          ? value.prescriptionId.toString()
                          : prescriptionIdController.text;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a prescription';
                      }
                      return null;
                    },
                    hintText: "Select prescription",
                  ),
                  const SizedBox(height: 16),
                  SubtlyRoundedElevatedButton(
                    onPressed: () {
                      createOrder(identityProvider.identity?['token']);
                    },
                    child: _isCreating
                        ? const CircularProgressIndicator()
                        : const Text("Send the order"),
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
