class MonthlyComparisonItem {
  final int year;
  final int month;
  final double income;
  final double expense;
  final double netAmount;
  final double carriedOver;

  MonthlyComparisonItem({
    required this.year,
    required this.month,
    required this.income,
    required this.expense,
    required this.netAmount,
    required this.carriedOver,
  });

  factory MonthlyComparisonItem.fromJson(Map<String, dynamic> json) =>
      MonthlyComparisonItem(
        year: json['year'] ?? 0,
        month: json['month'] ?? 0,
        income: (json['income'] ?? 0).toDouble(),
        expense: (json['expense'] ?? 0).toDouble(),
        netAmount: (json['netAmount'] ?? 0).toDouble(),
        carriedOver: (json['carriedOver'] ?? 0).toDouble(),
      );
}
