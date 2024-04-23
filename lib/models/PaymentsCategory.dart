class PaymentsCategory {
  final int id;
  final String name;
  final int customerId;
  final String createdAt;
  final String updatedAt;
  final double total;
  final double budget;
  final double percentage;

  PaymentsCategory({
    required this.id,
    required this.name,
    required this.customerId,
    required this.createdAt,
    required this.updatedAt,
    this.total = 0,
    this.budget = 0,
    this.percentage = 0,
  });

  factory PaymentsCategory.fromJson(Map<String, dynamic> json) {
    return PaymentsCategory(
      id: json['id'],
      name: json['name'],
      customerId: json['customer_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      total: json['total'] != null ? double.parse(json['total'].toString()) : 0,
      budget:
          json['budget'] != null ? double.parse(json['budget'].toString()) : 0,
      percentage: json['percentage'] != null
          ? double.parse(json['percentage'].toString())
          : 0,
    );
  }

  @override
  String toString() {
    return 'PaymentsCategory{id: $id, name: $name, customerId: $customerId, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
