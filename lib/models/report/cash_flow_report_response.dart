import 'cash_flow_detail_item.dart';

class CashFlowReportResponse {
  final int year;
  final int month;
  final double openingBalance;
  final double totalIncome;
  final double totalExpense;
  final double netCashFlow;
  final double closingBalance;
  final List<CashFlowDetailItem>? incomeDetails;
  final List<CashFlowDetailItem>? expenseDetails;

  CashFlowReportResponse({
    required this.year,
    required this.month,
    required this.openingBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.netCashFlow,
    required this.closingBalance,
    this.incomeDetails,
    this.expenseDetails,
  });

  factory CashFlowReportResponse.fromJson(Map<String, dynamic> json) =>
      CashFlowReportResponse(
        year: json['year'] ?? 0,
        month: json['month'] ?? 0,
        openingBalance: (json['openingBalance'] ?? 0).toDouble(),
        totalIncome: (json['totalIncome'] ?? 0).toDouble(),
        totalExpense: (json['totalExpense'] ?? 0).toDouble(),
        netCashFlow: (json['netCashFlow'] ?? 0).toDouble(),
        closingBalance: (json['closingBalance'] ?? 0).toDouble(),
        incomeDetails: (json['incomeDetails'] as List?)
            ?.map((e) => CashFlowDetailItem.fromJson(e))
            .toList(),
        expenseDetails: (json['expenseDetails'] as List?)
            ?.map((e) => CashFlowDetailItem.fromJson(e))
            .toList(),
      );
}
