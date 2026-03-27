class CashFlowDetailItem {
  final String? transactionTypeName;
  final double amount;
  final int transactionCount;

  CashFlowDetailItem({
    this.transactionTypeName,
    required this.amount,
    required this.transactionCount,
  });

  factory CashFlowDetailItem.fromJson(Map<String, dynamic> json) =>
      CashFlowDetailItem(
        transactionTypeName: json['transactionTypeName'],
        amount: (json['amount'] ?? 0).toDouble(),
        transactionCount: json['transactionCount'] ?? 0,
      );
}
