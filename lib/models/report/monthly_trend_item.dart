class MonthlyTrendItem {
  final int year;
  final int month;
  final double income;
  final double expense;
  final double netAmount;
  final double balance;

  MonthlyTrendItem({
    required this.year,
    required this.month,
    required this.income,
    required this.expense,
    required this.netAmount,
    required this.balance,
  });

  factory MonthlyTrendItem.fromJson(Map<String, dynamic> json) =>
      MonthlyTrendItem(
        year: json['year'] ?? 0,
        month: json['month'] ?? 0,
        income: (json['income'] ?? 0).toDouble(),
        expense: (json['expense'] ?? 0).toDouble(),
        netAmount: (json['netAmount'] ?? 0).toDouble(),
        balance: (json['balance'] ?? 0).toDouble(),
      );
}
