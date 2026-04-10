import '../core/network/api_client.dart';
import '../core/constants/api_constants.dart';
import '../models/transaction_type/transaction_type_response.dart';
import '../models/transaction_type/create_transaction_type_request.dart';
import '../models/transaction_type/update_transaction_type_request.dart';

class TransactionTypeService {
  final ApiClient _client;
  TransactionTypeService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<TransactionTypeResponse> create(CreateTransactionTypeRequest req) async {
    final res = await _client.post(ApiConstants.transactionType, body: req.toJson());
    return TransactionTypeResponse.fromJson(res['data']);
  }

  Future<TransactionTypeResponse> update(UpdateTransactionTypeRequest req) async {
    final res = await _client.put(ApiConstants.transactionType, body: req.toJson());
    return TransactionTypeResponse.fromJson(res['data']);
  }

  Future<void> delete(int id) async {
    await _client.delete(ApiConstants.transactionTypeById(id));
  }

  Future<List<TransactionTypeResponse>> getByUser(int userId) async {
    final res = await _client.get(ApiConstants.transactionTypeByUser(userId));
    return (res['data'] as List)
        .map((e) => TransactionTypeResponse.fromJson(e))
        .toList();
  }
}
