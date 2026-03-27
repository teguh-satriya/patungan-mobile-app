import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import '../models/auth/registration_request.dart';
import '../core/utils/token_storage.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthController extends ChangeNotifier {
  final AuthService _service;

  AuthStatus _status = AuthStatus.unknown;
  AuthStatus get status => _status;

  LoginResponse? _user;
  LoginResponse? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  AuthController({AuthService? service}) : _service = service ?? AuthService();

  Future<void> checkAuth() async {
    final loggedIn = await TokenStorage.isLoggedIn();
    _status = loggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _service.login(LoginRequest(email: email, password: password));
      _user = res;
      await TokenStorage.save(
        token: res.token ?? '',
        refreshToken: res.refreshToken ?? '',
        userId: res.userId,
        userName: res.userName ?? '',
      );
      _status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('ApiException', '').trim();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String userName, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.register(RegistrationRequest(
        userName: userName,
        email: email,
        password: password,
      ));
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('ApiException', '').trim();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final rt = await TokenStorage.getRefreshToken();
    if (rt != null) {
      try {
        await _service.revokeToken(rt);
      } catch (_) {}
    }
    await TokenStorage.clear();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
