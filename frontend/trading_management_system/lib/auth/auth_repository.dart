import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/app_config.dart';
import 'auth_models.dart';

abstract interface class AuthRepository {
  /// Returns a session or throws [AuthException].
  Future<AuthSession> login(String username, String password);
}

/// Logs in with `POST {API_BASE_URL}{API_LOGIN_PATH}`.
///
/// Request:  `{"username": "...", "password": "..."}`
/// Response: `{"token": "...", "role": "admin" | "broker", "username": "..."}`
/// (`access` is accepted in place of `token`, for JWT-style backends.)
///
/// If your backend differs, this class and [_parse] are the only places to
/// change.
class HttpAuthRepository implements AuthRepository {
  HttpAuthRepository({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  final http.Client _client;
  final String _baseUrl;

  static const _timeout = Duration(seconds: 15);

  @override
  Future<AuthSession> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl${AppConfig.loginPath}');

    final http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const AuthException(
          'The server took too long to respond. Please try again.');
    } on Exception {
      throw const AuthException(
          'Can’t reach the server. Check your connection and try again.');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return _parse(response.body, username);
      case 400:
      case 401:
        throw const AuthException('Incorrect username or password.');
      case 403:
        throw const AuthException(
            'This account doesn’t have access. Contact your admin.');
      case 429:
        throw const AuthException('Too many attempts. Wait a moment and retry.');
      default:
        throw AuthException(
            'Something went wrong on our side (${response.statusCode}).');
    }
  }

  AuthSession _parse(String body, String enteredUsername) {
    try {
      final map = jsonDecode(body) as Map<String, dynamic>;
      final token = (map['token'] ?? map['access']) as String?;
      final role = UserRole.tryParse(map['role']);
      if (token == null || token.isEmpty || role == null) {
        throw const FormatException('missing token or role');
      }
      return AuthSession(
        token: token,
        username: (map['username'] as String?) ?? enteredUsername,
        role: role,
      );
    } on FormatException {
      throw const AuthException('Unexpected response from the server.');
    } on TypeError {
      throw const AuthException('Unexpected response from the server.');
    }
  }
}
