import '../models/order.dart';
import '../models/user.dart';

class AppState {
  final User? user;
  final List<Order> orders;

  AppState({
    required this.user,
    required this.orders,
  });

  AppState copyWith({
    User? user,
    List<Order>? orders,
  }) {
    return AppState(
      user: user ?? this.user,
      orders: orders ?? this.orders,
    );
  }

  factory AppState.initial() {
    return AppState(user: null, orders: []);
  }
}