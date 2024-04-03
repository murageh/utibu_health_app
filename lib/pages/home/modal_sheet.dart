import 'package:flutter/material.dart';
import 'package:utibu_health_app/pages/forms/new_medication.dart';
import 'package:utibu_health_app/pages/forms/new_order.dart';
import 'package:utibu_health_app/pages/forms/new_prescription.dart';

// has the title, subtitle, thirdLine*, onTap callback
class ModalSheetItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isThreeLine;
  final VoidCallback onTap;

  ModalSheetItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isThreeLine,
    required this.onTap,
  });
}

List<ModalSheetItem> pharmacistItems(BuildContext context) => [
      ModalSheetItem(
        icon: Icons.medical_services,
        title: 'New Medication',
        subtitle: 'Add a new drug to your inventory',
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewMedicationPage()),
          );
        },
      ),
      ModalSheetItem(
        icon: Icons.medical_services,
        title: 'New Prescription',
        subtitle: 'Create a new prescription on behalf of a patient',
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NewPrescriptionPage()),
          );
        },
      ),
    ];

List<ModalSheetItem> userItems(BuildContext context) => [
      // new prescription and order
      ModalSheetItem(
        icon: Icons.medical_services,
        title: 'New Prescription',
        subtitle:
            'Record a new prescription for your medication. Prescription will be verified by the pharmacist',
        isThreeLine: true,
        onTap: () {
          // show confirmation dialog that the pharmacist will have to verify this prescription before the user can pay or pick it up
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('New Prescription'),
                content: const Text(
                  'Are you sure you want to create a new prescription?\nPrescriptions will be verified by the pharmacist before you can pay or pick it up',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewPrescriptionPage()),
                      );
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
        },
      ),
      ModalSheetItem(
        icon: Icons.medical_services,
        title: 'New Order',
        subtitle:
            'Place a new order for your medication. Order will be verified by the pharmacist',
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewOrderPage()),
          );
        },
      ),
    ];

Container modalSheetContent(BuildContext context, List<ModalSheetItem> items) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 32.0),
    child: ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(items[index].icon),
          title: Text(items[index].title),
          subtitle: Text(
            items[index].subtitle,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          isThreeLine: items[index].isThreeLine,
          onTap: items[index].onTap,
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: items.length,
    ),
  );
}
