import 'package:flutter/material.dart';
import '../services/summary_service.dart';
import '../models/summary/monthly_summary_response.dart';

class SummaryController extends ChangeNotifier {
  final SummaryService _service;
  SummaryController({SummaryService? service}) : _service = service ?? SummaryService();

  MonthlySummaryResponse? monthly;
  List<MonthlySummaryResponse> yearly = [];

  bool isLoading = false;
  String? error;

  Future<void> loadMonthly(int userId, int year, int month) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      monthly = await _service.getMonthlySummary(userId, year, month);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadYearly(int userId, int year) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      yearly = await _service.getYearlySummary(userId, year);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
