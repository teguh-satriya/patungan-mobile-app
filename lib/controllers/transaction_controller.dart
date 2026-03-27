import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../models/transaction/transaction_response.dart';
import '../models/transaction/create_transaction_request.dart';
import '../models/transaction/update_transaction_request.dart';

class TransactionController extends ChangeNotifier {
  final TransactionService _service;
  TransactionController({TransactionService? service})
      : _service = service ?? TransactionService();

  List<TransactionResponse> transactions = [];
  bool isLoading = false;
  String? error;
  String? successMessage;

  Future<void> loadMonthly(int userId, int year, int month) async {
    _setLoading();
    try {
      transactions = await _service.getMonthly(userId, year, month);
    } catch (e) {
      error = e.toString();
    } finally {
      _done();
    }
  }

  Future<bool> create(CreateTransactionRequest req) async {
    _setLoading();
    try {
      final t = await _service.create(req);
      transactions.insert(0, t);
      successMessage = 'Transaction added successfully';
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _done();
    }
  }

  Future<bool> update(int id, UpdateTransactionRequest req) async {
    _setLoading();
    try {
      final updated = await _service.update(id, req);
      final idx = transactions.indexWhere((t) => t.id == id);
      if (idx != -1) transactions[idx] = updated;
      successMessage = 'Transaction updated successfully';
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _done();
    }
  }

  Future<bool> delete(int id) async {
    _setLoading();
    try {
      await _service.delete(id);
      transactions.removeWhere((t) => t.id == id);
      successMessage = 'Transaction deleted';
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _done();
    }
  }

  void clearMessages() {
    error = null;
    successMessage = null;
    notifyListeners();
  }

  void _setLoading() {
    isLoading = true;
    error = null;
    successMessage = null;
    notifyListeners();
  }

  void _done() {
    isLoading = false;
    notifyListeners();
  }
}
