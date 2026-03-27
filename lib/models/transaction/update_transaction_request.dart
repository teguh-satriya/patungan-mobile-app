class UpdateTransactionRequest {
  final int transactionTypeId;
  final String date;
  final double amount;
  final String? notes;

  UpdateTransactionRequest({
    required this.transactionTypeId,
    required this.date,
    required this.amount,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'transactionTypeId': transactionTypeId,
        'date': date,
        'amount': amount,
        'notes': notes,
      };
}
