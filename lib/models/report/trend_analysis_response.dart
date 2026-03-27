import 'monthly_trend_item.dart';

class TrendAnalysisResponse {
  final int monthsAnalyzed;
  final double averageIncome;
  final double averageExpense;
  final double averageNetAmount;
  final double highestIncome;
  final double highestExpense;
  final double lowestIncome;
  final double lowestExpense;
  final List<MonthlyTrendItem>? monthlyTrends;
  final String? trendDirection;

  TrendAnalysisResponse({
    required this.monthsAnalyzed,
    required this.averageIncome,
    required this.averageExpense,
    required this.averageNetAmount,
    required this.highestIncome,
    required this.highestExpense,
    required this.lowestIncome,
    required this.lowestExpense,
    this.monthlyTrends,
    this.trendDirection,
  });

  factory TrendAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      TrendAnalysisResponse(
        monthsAnalyzed: json['monthsAnalyzed'] ?? 0,
        averageIncome: (json['averageIncome'] ?? 0).toDouble(),
        averageExpense: (json['averageExpense'] ?? 0).toDouble(),
        averageNetAmount: (json['averageNetAmount'] ?? 0).toDouble(),
        highestIncome: (json['highestIncome'] ?? 0).toDouble(),
        highestExpense: (json['highestExpense'] ?? 0).toDouble(),
        lowestIncome: (json['lowestIncome'] ?? 0).toDouble(),
        lowestExpense: (json['lowestExpense'] ?? 0).toDouble(),
        monthlyTrends: (json['monthlyTrends'] as List?)
            ?.map((e) => MonthlyTrendItem.fromJson(e))
            .toList(),
        trendDirection: json['trendDirection'],
      );
}
