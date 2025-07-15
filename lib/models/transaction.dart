/// Transaction model representing a single transaction item.
class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final String type;
  final String status;
  final String description;

  const Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
    required this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      status: json['status'] as String,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'date': date.toIso8601String(),
    'type': type,
    'status': status,
    'description': description,
  };

  Transaction copyWith({
    String? id,
    double? amount,
    DateTime? date,
    String? type,
    String? status,
    String? description,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      status: status ?? this.status,
      description: description ?? this.description,
    );
  }
}
