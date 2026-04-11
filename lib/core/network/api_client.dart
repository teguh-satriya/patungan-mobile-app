import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/token_storage.dart';
import '../constants/api_constants.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? _createClient();

  static http.Client _createClient() {
    final httpClient = HttpClient();
    if (dotenv.env['DEVELOPMENT_MODE'] == 'true') {
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    }
    return IOClient(httpClient);
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await TokenStorage.getToken();
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }

  Uri _uri(String path) => Uri.parse('${ApiConstants.baseUrl}$path');

  /// Attempts to refresh the access token using the stored refresh token.
  /// Returns true if successful, false otherwise.
  Future<bool> _tryRefreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;
    try {
      final res = await _client.post(
        _uri(ApiConstants.refreshToken),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body)['data'] as Map<String, dynamic>;
        final newToken = data['accessToken'] as String?;
        final newRefresh = data['refreshToken'] as String?;
        if (newToken != null) {
          final userId = await TokenStorage.getUserId();
          final userName = await TokenStorage.getUserName();
          await TokenStorage.save(
            token: newToken,
            refreshToken: newRefresh ?? refreshToken,
            userId: userId ?? 0,
            userName: userName ?? '',
          );
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  Future<dynamic> get(String path) async {
    var res = await _client.get(_uri(path), headers: await _authHeaders());
    if (res.statusCode == 401 && await _tryRefreshToken()) {
      res = await _client.get(_uri(path), headers: await _authHeaders());
    }
    return _handle(res);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    var res = await _client.post(
      _uri(path),
      headers: await _authHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );
    if (res.statusCode == 401 && !path.contains('/Auth/') && await _tryRefreshToken()) {
      res = await _client.post(
        _uri(path),
        headers: await _authHeaders(),
        body: body != null ? jsonEncode(body) : null,
      );
    }
    return _handle(res);
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    var res = await _client.put(
      _uri(path),
      headers: await _authHeaders(),
      body: body != null ? jsonEncode(body) : null,
    );
    if (res.statusCode == 401 && await _tryRefreshToken()) {
      res = await _client.put(
        _uri(path),
        headers: await _authHeaders(),
        body: body != null ? jsonEncode(body) : null,
      );
    }
    return _handle(res);
  }

  Future<dynamic> delete(String path) async {
    var res = await _client.delete(_uri(path), headers: await _authHeaders());
    if (res.statusCode == 401 && await _tryRefreshToken()) {
      res = await _client.delete(_uri(path), headers: await _authHeaders());
    }
    return _handle(res);
  }

  dynamic _handle(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      // ignore: avoid_print
      print('[API] ${res.request?.url} → ${res.body}');
      return jsonDecode(res.body);
    }

    String message;
    try {
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      // ASP.NET ProblemDetails / validation errors
      final errors = decoded['errors'];
      if (errors is Map && errors.isNotEmpty) {
        message = (errors.values.first as List).first.toString();
      } else {
        message = (decoded['message'] ??
                decoded['title'] ??
                decoded['detail'] ??
                decoded['error'] ??
                res.body)
            .toString();
      }
    } catch (_) {
      message = res.body.isNotEmpty ? res.body : 'HTTP ${res.statusCode}';
    }

    throw ApiException(res.statusCode, message);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
