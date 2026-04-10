class TransactionResponse {
  final int id;
  final int monthlySummaryId;
  final int transactionTypeId;
  final String? transactionTypeName;
  final String? transactionTypeIcon;
  final String? transactionNature;
  final DateTime date;
  final double amount;
  final String? notes;
  final int userId;
  final DateTime createdAt;

  TransactionResponse({
    required this.id,
    required this.monthlySummaryId,
    required this.transactionTypeId,
    this.transactionTypeName,
    this.transactionTypeIcon,
    this.transactionNature,
    required this.date,
    required this.amount,
    this.notes,
    required this.userId,
    required this.createdAt,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      TransactionResponse(
        id: json['id'] ?? 0,
        monthlySummaryId: json['monthlySummaryId'] ?? 0,
        transactionTypeId: json['transactionTypeId'] ?? 0,
        transactionTypeName: json['transactionTypeName'],
        transactionTypeIcon: json['transactionTypeIcon'],
        transactionNature: json['transactionNature'],
        date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
        amount: (json['amount'] ?? 0).toDouble(),
        notes: json['notes'],
        userId: json['userId'] ?? 0,
        createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      );
}
