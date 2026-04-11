import 'package:flutter/material.dart';
import '../services/report_service.dart';
import '../models/budget/carryover_history_response.dart';
import '../models/report/cash_flow_report_response.dart';
import '../models/report/income_expense_comparison_response.dart';
import '../models/report/trend_analysis_response.dart';

class ReportController extends ChangeNotifier {
  final ReportService _service;
  ReportController({ReportService? service}) : _service = service ?? ReportService();

  CashFlowReportResponse? cashflow;
  IncomeExpenseComparisonResponse? comparison;
  TrendAnalysisResponse? trend;
  CarryoverHistoryResponse? carryoverHistory;

  bool isLoading = false;
  bool carryoverLoading = false;
  String? error;
  String? cashflowError;
  String? comparisonError;
  String? trendError;
  String? carryoverError;

  static Future<T?> _safe<T>(Future<T> future) async {
    try {
      return await future;
    } catch (_) {
      return null;
    }
  }

  Future<void> loadAll(int userId, int year, int month) async {
    isLoading = true;
    error = null;
    cashflowError = null;
    trendError = null;
    notifyListeners();
    try {
      final cf = _service.getCashflow(userId, year, month);
      final tr = _service.getTrendAnalysis(userId);

      await Future.wait([
        cf.then((v) => cashflow = v).catchError((e) { cashflowError = e.toString(); return null; }),
        tr.then((v) => trend = v).catchError((e) { trendError = e.toString(); return null; }),
      ]);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool comparisonLoading = false;

  Future<void> loadComparison(
      int userId, int fromYear, int fromMonth, int toYear, int toMonth) async {
    comparisonLoading = true;
    comparisonError = null;
    comparison = null;
    notifyListeners();
    try {
      comparison = await _service.getIncomeExpenseComparison(
          userId, fromYear, fromMonth, toYear, toMonth);
    } catch (e) {
      comparisonError = e.toString();
      comparison = null;
    } finally {
      comparisonLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCarryoverHistory(
      int userId, int fromYear, int fromMonth, int toYear, int toMonth) async {
    carryoverLoading = true;
    carryoverError = null;
    notifyListeners();
    try {
      carryoverHistory = await _service.getCarryoverHistory(
          userId, fromYear, fromMonth, toYear, toMonth);
    } catch (e) {
      carryoverError = e.toString();
      carryoverHistory = null;
    } finally {
      carryoverLoading = false;
      notifyListeners();
    }
  }
}
