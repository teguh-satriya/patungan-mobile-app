import '../core/network/api_client.dart';
import '../core/constants/api_constants.dart';
import '../models/summary/monthly_summary_response.dart';

class SummaryService {
  final ApiClient _client;
  SummaryService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<MonthlySummaryResponse> getMonthlySummary(int userId, int year, int month) async {
    final res = await _client.get(ApiConstants.monthlySummary(userId, year, month));
    return MonthlySummaryResponse.fromJson(res['data']);
  }

  Future<List<MonthlySummaryResponse>> getYearlySummary(int userId, int year) async {
    final res = await _client.get(ApiConstants.yearlySummary(userId, year));
    return (res['data'] as List)
        .map((e) => MonthlySummaryResponse.fromJson(e))
        .toList();
  }

  Future<void> recalculate(int userId, int year, int month) async {
    await _client.post(ApiConstants.recalculateSummary(userId, year, month));
  }

  Future<void> carryover(int userId, int year, int month) async {
    await _client.post(ApiConstants.carryoverSummary(userId, year, month));
  }
}
