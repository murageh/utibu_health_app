
import 'package:utibu_health_app/models/prescription.dart';

class Order {
  final int orderId;
  final int userId;
  final int medicationId;
  final int quantity;
  final DateTime orderDate;
  final String orderStatus;
  final String paymentStatus;
  final Prescription prescription;

  Order({
    required this.orderId,
    required this.userId,
    required this.medicationId,
    required this.quantity,
    required this.orderDate,
    required this.orderStatus,
    required this.paymentStatus,
    required this.prescription,
  });

  Order copyWith({
    required int orderId,
    required int userId,
    required int medicationId,
    required int quantity,
    required DateTime orderDate,
    required String orderStatus,
    required String paymentStatus,
    required Prescription prescription,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      medicationId: medicationId ?? this.medicationId,
      quantity: quantity ?? this.quantity,
      orderDate: orderDate ?? this.orderDate,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      prescription: prescription ?? this.prescription,
    );
  }

  toJSON() {
    Map<String, dynamic> m = {};

    m['order_id'] = orderId;
    m['user_id'] = userId;
    m['medication_id'] = medicationId;
    m['quantity'] = quantity;
    m['order_date'] = orderDate;
    m['order_status'] = orderStatus;
    m['payment_status'] = paymentStatus;
    m['prescription'] = prescription.toJSON();

    return m;
  }

  static fromJSON(Map<String, dynamic> m) {
    return Order(
      orderId: m['order_id'],
      userId: m['user_id'],
      medicationId: m['medication_id'],
      quantity: m['quantity'],
      orderDate: m['order_date'],
      orderStatus: m['order_status'],
      paymentStatus: m['payment_status'],
      prescription: Prescription.fromJSON(m['prescription']),
    );
  }
}