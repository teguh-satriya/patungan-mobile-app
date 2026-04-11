import '../core/network/api_client.dart';
import '../core/constants/api_constants.dart';
import '../models/budget/budget_overview_response.dart';
import '../models/budget/transaction_type_budget_response.dart';
import '../models/budget/carryover_history_response.dart';

class BudgetService {
  final ApiClient _client;
  BudgetService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<BudgetOverviewResponse> getOverview(int userId, int year, int month) async {
    final res = await _client.get(ApiConstants.budgetOverview(userId, year, month));
    return BudgetOverviewResponse.fromJson(res['data']);
  }

  Future<List<TransactionTypeBudgetResponse>> getSpendingByType(
      int userId, int year, int month) async {
    final res = await _client.get(ApiConstants.spendingByType(userId, year, month));
    return (res['data'] as List)
        .map((e) => TransactionTypeBudgetResponse.fromJson(e))
        .toList();
  }

  Future<double> getProjectedBalance(int userId, int year, int month) async {
    final res = await _client.get(ApiConstants.projectedBalance(userId, year, month));
    return (res['data'] ?? 0).toDouble();
  }

  Future<CarryoverHistoryResponse> getCarryoverHistory(int userId) async {
    final now = DateTime.now();
    final fromYear = now.year - 1;
    const fromMonth = 1;
    final toYear = now.year;
    final toMonth = now.month;
    final res = await _client.get(
        ApiConstants.carryoverHistory(userId, fromYear, fromMonth, toYear, toMonth));
    return CarryoverHistoryResponse.fromJson(res['data']);
  }
}
