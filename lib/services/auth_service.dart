import '../core/network/api_client.dart';
import '../core/constants/api_constants.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import '../models/auth/registration_request.dart';
import '../models/auth/refresh_token_request.dart';
import '../models/auth/refresh_token_response.dart';

class AuthService {
  final ApiClient _client;
  AuthService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<LoginResponse> login(LoginRequest req) async {
    final res = await _client.post(ApiConstants.login, body: req.toJson());
    return LoginResponse.fromJson(res['data']);
  }

  Future<void> register(RegistrationRequest req) async {
    await _client.post(ApiConstants.register, body: req.toJson());
  }

  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest req) async {
    final res = await _client.post(ApiConstants.refreshToken, body: req.toJson());
    return RefreshTokenResponse.fromJson(res['data']);
  }

  Future<void> revokeToken(String refreshToken) async {
    await _client.post(ApiConstants.revokeToken, body: {'refreshToken': refreshToken});
  }
}
