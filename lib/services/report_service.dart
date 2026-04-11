import '../core/network/api_client.dart';
import '../core/constants/api_constants.dart';
import '../models/budget/carryover_history_response.dart';
import '../models/report/cash_flow_report_response.dart';
import '../models/report/income_expense_comparison_response.dart';
import '../models/report/trend_analysis_response.dart';

class ReportService {
  final ApiClient _client;
  ReportService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<CashFlowReportResponse> getCashflow(int userId, int year, int month) async {
    final res = await _client.get(ApiConstants.cashflow(userId, year, month));
    return CashFlowReportResponse.fromJson(res['data']);
  }

  Future<IncomeExpenseComparisonResponse> getIncomeExpenseComparison(
      int userId, int startYear, int startMonth, int endYear, int endMonth) async {
    final res = await _client.get(
        ApiConstants.incomeExpenseComparison(userId, startYear, startMonth, endYear, endMonth));
    return IncomeExpenseComparisonResponse.fromJson(res['data']);
  }

  Future<TrendAnalysisResponse> getTrendAnalysis(int userId) async {
    final res = await _client.get(ApiConstants.trendAnalysis(userId));
    return TrendAnalysisResponse.fromJson(res['data']);
  }

  Future<CarryoverHistoryResponse> getCarryoverHistory(
      int userId, int fromYear, int fromMonth, int toYear, int toMonth) async {
    final res = await _client.get(
        ApiConstants.carryoverHistory(userId, fromYear, fromMonth, toYear, toMonth));
    return CarryoverHistoryResponse.fromJson(res['data']);
  }
}
