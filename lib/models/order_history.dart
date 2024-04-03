
class OrderHistory {
  final int orderHistoryId;
  final int userId;

  OrderHistory({
    required this.orderHistoryId,
    required this.userId,
  });

  OrderHistory copyWith({
    required int orderHistoryId,
    required int userId,
  }) {
    return OrderHistory(
      orderHistoryId: orderHistoryId ?? this.orderHistoryId,
      userId: userId ?? this.userId,
    );
  }

  toJSON() {
    Map<String, dynamic> m = {};

    m['order_history_id'] = orderHistoryId;
    m['user_id'] = userId;

    return m;
  }

  static fromJSON(Map<String, dynamic> m) {
    return OrderHistory(
      orderHistoryId: m['order_history_id'],
      userId: m['user_id'],
    );
  }
}