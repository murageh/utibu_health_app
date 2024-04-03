import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:utibu_health_app/components/app_bar.dart';
import 'package:utibu_health_app/models/medication.dart';
import 'package:utibu_health_app/models/order.dart';
import 'package:utibu_health_app/models/prescription.dart';
import 'package:utibu_health_app/models/user.dart';
import 'package:utibu_health_app/pages/lists/view_list.dart';
import 'package:utibu_health_app/pages/login_page.dart';
import 'package:utibu_health_app/providers/identity/Identityprovider.dart';
import 'package:utibu_health_app/services/api_service.dart';

class PrescriptionList extends StatefulWidget {
  const PrescriptionList({super.key});

  @override
  State<PrescriptionList> createState() => _PrescriptionListState();
}

class _PrescriptionListState extends State<PrescriptionList> {
  String title = 'Prescription';
  List<Prescription> prescriptions = [];

  void getPrescriptions(String? token) async {
    await ApiService().getPrescriptions(token).then((value) {
      setState(() {
        prescriptions = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    IdentityProvider identityProvider =
        Provider.of<IdentityProvider>(context, listen: false);
    getPrescriptions(identityProvider.identity?['token']);
  }

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('yyyy-MM-dd');
    final detailedF = DateFormat('yyyy-MM-dd HH:mm:ss');

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
          items: prescriptions
              .map((prescriptions) => Item(
                  title: '${prescriptions.medication?.name} (${prescriptions.dosage})',
                  subtitle: '${f.format(prescriptions.date)} by ${prescriptions.doctorName}',
                  thirdLine: 'For ${prescriptions.user?.name}',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Medication Details'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Medication: ${prescriptions.medication?.name} (${prescriptions.medication?.description})'),
                              Text('Dosage: ${prescriptions.dosage}'),
                              Text('Prescription Date: ${detailedF.format(prescriptions.date)}'),
                              Text('Doctor: ${prescriptions.doctorName}'),
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
                      },
                    );
                  }))
              .toList(),
        ),
      );
    });
  }
}
