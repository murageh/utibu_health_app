
import 'package:intl/intl.dart';
import 'package:utibu_health_app/models/medication.dart';
import 'package:utibu_health_app/models/user.dart';

class Prescription {
  final int prescriptionId;
  final int userId;
  final User? user;
  final Medication? medication;
  final String doctorName;
  final String prescriptionDate;
  final String dosage;
  final int refillCount;
  final int quantity;

  String get dateString => DateFormat('yyyy-MM-dd').format(DateTime.parse(prescriptionDate));

  DateTime get date => DateTime.parse(prescriptionDate);

  Prescription({
    required this.prescriptionId,
    required this.userId,
    this.medication,
    this.user,
    required this.doctorName,
    required this.prescriptionDate,
    required this.quantity,
    required this.dosage,
    required this.refillCount,
  });

  Prescription copyWith({
    required int prescriptionId,
    required int userId,
    Medication? medication,
    User? user,
    required String doctorName,
    required String prescriptionDate,
    required int quantity,
    required String dosage,
    required int refillCount,
  }) {
    return Prescription(
      prescriptionId: prescriptionId ?? this.prescriptionId,
      userId: userId ?? this.userId,
      medication: medication ?? this.medication,
      user: user ?? this.user,
      doctorName: doctorName ?? this.doctorName,
      prescriptionDate: prescriptionDate ?? this.prescriptionDate,
      dosage: dosage ?? this.dosage,
      quantity: quantity ?? this.quantity,
      refillCount: refillCount ?? this.refillCount,
    );
  }

  toJSON() {
    Map<String, dynamic> m = {};

    m['prescription_id'] = prescriptionId;
    m['user_id'] = userId;
    m['medication'] = medication?.toJSON();
    m['user'] = user?.toJSON();
    m['doctor_name'] = doctorName;
    m['prescription_date'] = prescriptionDate;
    m['dosage'] = dosage;
    m['quantity'] = quantity;
    m['refill_count'] = refillCount;

    return m;
  }

  static fromJSON(Map<String, dynamic> m) {
    return Prescription(
      prescriptionId: m['prescription_id'],
      userId: m['user_id'],
      medication: m['medication'] != null ? Medication.fromJSON(m['medication']) : null,
      user: m['user'] != null ? User.fromJSON(m['user']) : null,
      doctorName: m['doctor_name'],
      prescriptionDate: m['prescription_date'],
      dosage: m['dosage'],
      quantity: m['quantity'],
      refillCount: m['refill_count'],
    );
  }
}

class NewPrescription {
  final int userId;
  final int medicationId;
  final String doctorName;
  final String prescriptionDate;
  final String dosage;
  final int quantity;
  final int refillCount;

  String get dateString => DateFormat('yyyy-MM-dd').format(DateTime.parse(prescriptionDate));

  DateTime get date => DateTime.parse(prescriptionDate);

  NewPrescription({
    required this.userId,
    required this.medicationId,
    required this.doctorName,
    required this.prescriptionDate,
    required this.dosage,
    required this.quantity,
    required this.refillCount,
  });

  toJSON() {
    Map<String, dynamic> m = {};

    m['user_id'] = userId;
    m['medication_id'] = medicationId;
    m['doctor_name'] = doctorName;
    m['prescription_date'] = prescriptionDate;
    m['dosage'] = dosage;
    m['quantity'] = quantity;
    m['refill_count'] = refillCount;

    return m;
  }
}