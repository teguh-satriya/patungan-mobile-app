import 'monthly_carryover_item.dart';

class CarryoverHistoryResponse {
  final List<MonthlyCarryoverItem>? history;
  final double totalCarriedOver;
  final double averageCarryover;

  CarryoverHistoryResponse({
    this.history,
    required this.totalCarriedOver,
    required this.averageCarryover,
  });

  factory CarryoverHistoryResponse.fromJson(Map<String, dynamic> json) =>
      CarryoverHistoryResponse(
        history: (json['history'] as List?)
            ?.map((e) => MonthlyCarryoverItem.fromJson(e))
            .toList(),
        totalCarriedOver: (json['totalCarriedOver'] ?? 0).toDouble(),
        averageCarryover: (json['averageCarryover'] ?? 0).toDouble(),
      );
}
