class Transaction {
  final String id;
  final String userId;
  final String type;
  final double amount;
  final DateTime date;
  final String? description;
  final String? receiverPhoneNumber;
  final String? purpose;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.date,
    this.description,
    this.receiverPhoneNumber,
    this.purpose,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      userId: json['userId'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      description: json['description'],
      receiverPhoneNumber: json['receiverPhoneNumber'],
      purpose: json['purpose'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'receiverPhoneNumber': receiverPhoneNumber,
      'purpose': purpose,
    };
  }
}
