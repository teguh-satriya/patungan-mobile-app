import '../summary/monthly_comparison_item.dart';

class IncomeExpenseComparisonResponse {
  final DateTime startDate;
  final DateTime endDate;
  final double totalIncome;
  final double totalExpense;
  final double netAmount;
  final List<MonthlyComparisonItem>? monthlyBreakdown;

  IncomeExpenseComparisonResponse({
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpense,
    required this.netAmount,
    this.monthlyBreakdown,
  });

  factory IncomeExpenseComparisonResponse.fromJson(Map<String, dynamic> json) =>
      IncomeExpenseComparisonResponse(
        startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
        endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
        totalIncome: (json['totalIncome'] ?? 0).toDouble(),
        totalExpense: (json['totalExpense'] ?? 0).toDouble(),
        netAmount: (json['netAmount'] ?? 0).toDouble(),
        monthlyBreakdown: (json['monthlyBreakdown'] as List?)
            ?.map((e) => MonthlyComparisonItem.fromJson(e))
            .toList(),
      );
}
