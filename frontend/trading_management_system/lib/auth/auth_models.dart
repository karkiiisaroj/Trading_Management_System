import 'dart:convert';

/// Accounts are created by an admin; there is no self-registration.
enum UserRole {
  admin,
  broker;

  static UserRole? tryParse(Object? value) {
    final v = value?.toString().trim().toLowerCase();
    for (final role in UserRole.values) {
      if (role.name == v) return role;
    }
    return null;
  }

  String get label => this == admin ? 'Admin' : 'Broker';
}

class AuthSession {
  const AuthSession({
    required this.token,
    required this.username,
    required this.role,
  });

  final String token;
  final String username;
  final UserRole role;

  Map<String, dynamic> toJson() =>
      {'token': token, 'username': username, 'role': role.name};

  String encode() => jsonEncode(toJson());

  static AuthSession? tryDecode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final role = UserRole.tryParse(map['role']);
      final token = map['token'] as String?;
      final username = map['username'] as String?;
      if (role == null || token == null || username == null) return null;
      return AuthSession(token: token, username: username, role: role);
    } catch (_) {
      return null;
    }
  }
}

/// A sign-in failure with a message that is safe to show to the user.
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}
