import 'package:flutter/material.dart';
import '../services/transaction_type_service.dart';
import '../models/transaction_type/transaction_type_response.dart';
import '../models/transaction_type/create_transaction_type_request.dart';
import '../models/transaction_type/update_transaction_type_request.dart';

class TransactionTypeController extends ChangeNotifier {
  final TransactionTypeService _service;
  TransactionTypeController({TransactionTypeService? service})
      : _service = service ?? TransactionTypeService();

  List<TransactionTypeResponse> types = [];
  bool isLoading = false;
  String? error;
  String? successMessage;

  Future<void> loadByUser(int userId) async {
    _setLoading();
    try {
      types = await _service.getByUser(userId);
    } catch (e) {
      error = e.toString();
    } finally {
      _done();
    }
  }

  Future<bool> create(CreateTransactionTypeRequest req) async {
    _setLoading();
    try {
      final t = await _service.create(req);
      types.add(t);
      successMessage = 'Transaction type created';
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      _done();
    }
  }

  Future<bool> update(UpdateTransactionTypeRequest req) async {
    _setLoading();
    try {
      final updated = await _service.update(req);
      final idx = types.indexWhere((t) => t.id == req.id);
      if (idx != -1) types[idx] = updated;
      successMessage = 'Transaction type updated';
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
      types.removeWhere((t) => t.id == id);
      successMessage = 'Transaction type deleted';
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
