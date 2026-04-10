class TransactionTypeBudgetResponse {
  final int transactionTypeId;
  final String? transactionTypeName;
  final String? icon;
  final String? nature;
  final double totalAmount;
  final int transactionCount;
  final double percentage;

  TransactionTypeBudgetResponse({
    required this.transactionTypeId,
    this.transactionTypeName,
    this.icon,
    this.nature,
    required this.totalAmount,
    required this.transactionCount,
    required this.percentage,
  });

  factory TransactionTypeBudgetResponse.fromJson(Map<String, dynamic> json) =>
      TransactionTypeBudgetResponse(
        transactionTypeId: json['transactionTypeId'] ?? 0,
        transactionTypeName: json['transactionTypeName'],
        icon: json['icon'],
        nature: json['nature'],
        totalAmount: (json['totalAmount'] ?? 0).toDouble(),
        transactionCount: json['transactionCount'] ?? 0,
        percentage: (json['percentage'] ?? 0).toDouble(),
      );
}
