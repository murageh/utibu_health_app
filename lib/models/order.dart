import 'package:intl/intl.dart';
import 'package:utibu_health_app/models/prescription.dart';
import 'package:utibu_health_app/models/user.dart';

class Order {
  final int orderId;
  final int userId;
  final String orderDate;
  final String orderStatus;
  final String paymentStatus;
  final Prescription prescription;
  final User? user;

  get dateString => DateFormat('yyyy-MM-dd').format(DateTime.parse(orderDate));

  DateTime get date => DateTime.parse(orderDate);

  Order({
    required this.orderId,
    required this.userId,
    required this.orderDate,
    required this.orderStatus,
    required this.paymentStatus,
    required this.prescription,
    this.user,
  });

  Order copyWith({
    required int orderId,
    required int userId,
    required String orderDate,
    required String orderStatus,
    required String paymentStatus,
    required Prescription prescription,
    User? user,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      orderDate: orderDate ?? this.orderDate,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      prescription: prescription ?? this.prescription,
      user: user ?? this.user,
    );
  }

  toJSON() {
    Map<String, dynamic> m = {};

    m['order_id'] = orderId;
    m['user_id'] = userId;
    m['order_date'] = orderDate;
    m['order_status'] = orderStatus;
    m['payment_status'] = paymentStatus;
    m['prescription'] = prescription.toJSON();
    m['user'] = user?.toJSON();

    return m;
  }

  static fromJSON(Map<String, dynamic> m) {
    return Order(
      orderId: m['order_id'],
      userId: m['user_id'],
      orderDate: m['order_date'],
      orderStatus: m['order_status'],
      paymentStatus: m['payment_status'],
      prescription: Prescription.fromJSON(m['prescription']),
      user: m['user'] == null ? null : User.fromJSON(m['user']),
    );
  }
}