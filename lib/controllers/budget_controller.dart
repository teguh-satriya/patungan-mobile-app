import 'package:flutter/material.dart';
import '../services/budget_service.dart';
import '../models/budget/budget_overview_response.dart';
import '../models/budget/transaction_type_budget_response.dart';
import '../models/budget/carryover_history_response.dart';

class BudgetController extends ChangeNotifier {
  final BudgetService _service;
  BudgetController({BudgetService? service}) : _service = service ?? BudgetService();

  BudgetOverviewResponse? overview;
  List<TransactionTypeBudgetResponse> spendingByType = [];
  double? projectedBalance;
  CarryoverHistoryResponse? carryoverHistory;

  bool isLoading = false;
  String? error;

  Future<void> loadAll(int userId, int year, int month) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        _service.getOverview(userId, year, month),
        _service.getSpendingByType(userId, year, month),
        _service.getProjectedBalance(userId, year, month),
        _service.getCarryoverHistory(userId),
      ]);
      overview = results[0] as BudgetOverviewResponse;
      spendingByType = results[1] as List<TransactionTypeBudgetResponse>;
      projectedBalance = results[2] as double;
      carryoverHistory = results[3] as CarryoverHistoryResponse;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
