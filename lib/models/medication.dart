
class Medication {
  final int medicationId;
  final String name;
  final String unit;
  final String description;
  int stockLevel;
  final double price;

  setStockLevel(int newStockLevel) {
    stockLevel = newStockLevel;
  }

  Medication({
    required this.medicationId,
    required this.name,
    required this.description,
    required this.unit,
    required this.stockLevel,
    required this.price,
  });

  Medication copyWith({
    required int medicationId,
    required String name,
    required String description,
    required String unit,
    required int stockLevel,
    required double price,
  }) {
    return Medication(
      medicationId: medicationId ?? this.medicationId,
      name: name ?? this.name,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      stockLevel: stockLevel ?? this.stockLevel,
      price: price ?? this.price,
    );
  }

  toJSON() {
    Map<String, dynamic> m = {};
    m['medication_id'] = medicationId;
    m['name'] = name;
    m['description'] = description;
    m['unit'] = unit;
    m['stock_level'] = stockLevel;
    m['price'] = price;

    return m;
  }

  static fromJSON(Map<String, dynamic> m) {
    return Medication(
      medicationId: m['medication_id'],
      name: m['name'],
      description: m['description'],
      unit: m['unit'],
      stockLevel: m['stock_level'],
      price: double.parse(m['price'].toString()),
    );
  }
}