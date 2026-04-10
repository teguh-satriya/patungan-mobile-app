class CreateTransactionRequest {
  final int userId;
  final int transactionTypeId;
  final String date;
  final double amount;
  final String? notes;

  CreateTransactionRequest({
    required this.userId,
    required this.transactionTypeId,
    required this.date,
    required this.amount,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'userId': userId,
      'transactionTypeId': transactionTypeId,
      'date': date,
      'amount': amount,
    };
    if (notes != null) map['notes'] = notes;
    return map;
  }
}
