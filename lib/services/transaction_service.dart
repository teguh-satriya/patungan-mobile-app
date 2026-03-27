import '../core/network/api_client.dart';
import '../core/constants/api_constants.dart';
import '../models/transaction/transaction_response.dart';
import '../models/transaction/create_transaction_request.dart';
import '../models/transaction/update_transaction_request.dart';

class TransactionService {
  final ApiClient _client;
  TransactionService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<TransactionResponse> create(CreateTransactionRequest req) async {
    final res = await _client.post(ApiConstants.transaction, body: req.toJson());
    return TransactionResponse.fromJson(res['data']);
  }

  Future<TransactionResponse> update(int id, UpdateTransactionRequest req) async {
    final res = await _client.put(ApiConstants.transactionById(id), body: req.toJson());
    return TransactionResponse.fromJson(res['data']);
  }

  Future<void> delete(int id) async {
    await _client.delete(ApiConstants.transactionById(id));
  }

  Future<List<TransactionResponse>> getMonthly(int userId, int year, int month) async {
    final res = await _client.get(ApiConstants.monthlyTransactions(userId, year, month));
    return (res['data'] as List).map((e) => TransactionResponse.fromJson(e)).toList();
  }

  Future<List<TransactionResponse>> getByType(int userId, int typeId) async {
    final res = await _client.get(ApiConstants.transactionsByType(userId, typeId));
    return (res['data'] as List).map((e) => TransactionResponse.fromJson(e)).toList();
  }

  Future<List<TransactionResponse>> getIncome(int userId, int year, int month) async {
    final res = await _client.get(ApiConstants.incomeTransactions(userId, year, month));
    return (res['data'] as List).map((e) => TransactionResponse.fromJson(e)).toList();
  }

  Future<List<TransactionResponse>> getExpense(int userId, int year, int month) async {
    final res = await _client.get(ApiConstants.expenseTransactions(userId, year, month));
    return (res['data'] as List).map((e) => TransactionResponse.fromJson(e)).toList();
  }
}
