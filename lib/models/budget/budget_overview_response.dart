class BudgetOverviewResponse {
  final int year;
  final int month;
  final double startingBalance;
  final double totalIncome;
  final double totalExpense;
  final double currentBalance;
  final double carriedOverFromPrevious;
  final double projectedEndingBalance;
  final int transactionCount;

  BudgetOverviewResponse({
    required this.year,
    required this.month,
    required this.startingBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.currentBalance,
    required this.carriedOverFromPrevious,
    required this.projectedEndingBalance,
    required this.transactionCount,
  });

  factory BudgetOverviewResponse.fromJson(Map<String, dynamic> json) =>
      BudgetOverviewResponse(
        year: json['year'] ?? 0,
        month: json['month'] ?? 0,
        startingBalance: (json['startingBalance'] ?? 0).toDouble(),
        totalIncome: (json['totalIncome'] ?? 0).toDouble(),
        totalExpense: (json['totalExpense'] ?? 0).toDouble(),
        currentBalance: (json['currentBalance'] ?? 0).toDouble(),
        carriedOverFromPrevious: (json['carriedOverFromPrevious'] ?? 0).toDouble(),
        projectedEndingBalance: (json['projectedEndingBalance'] ?? 0).toDouble(),
        transactionCount: json['transactionCount'] ?? 0,
      );
}
