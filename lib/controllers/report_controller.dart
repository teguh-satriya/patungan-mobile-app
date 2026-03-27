import 'package:flutter/material.dart';
import '../services/report_service.dart';
import '../models/report/cash_flow_report_response.dart';
import '../models/report/income_expense_comparison_response.dart';
import '../models/report/trend_analysis_response.dart';

class ReportController extends ChangeNotifier {
  final ReportService _service;
  ReportController({ReportService? service}) : _service = service ?? ReportService();

  CashFlowReportResponse? cashflow;
  IncomeExpenseComparisonResponse? comparison;
  TrendAnalysisResponse? trend;

  bool isLoading = false;
  String? error;

  Future<void> loadAll(int userId, int year, int month) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _service.getCashflow(userId, year, month),
        _service.getIncomeExpenseComparison(userId),
        _service.getTrendAnalysis(userId),
      ]);
      cashflow = results[0] as CashFlowReportResponse;
      comparison = results[1] as IncomeExpenseComparisonResponse;
      trend = results[2] as TrendAnalysisResponse;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
