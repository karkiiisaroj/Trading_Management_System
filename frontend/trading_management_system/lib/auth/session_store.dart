import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_models.dart';

abstract interface class SessionStore {
  Future<AuthSession?> read();
  Future<void> write(AuthSession session);
  Future<void> clear();
}

/// Keeps the session in the platform keystore (Keychain / Keystore /
/// Credential Locker / libsecret; encrypted storage on web).
class SecureSessionStore implements SessionStore {
  SecureSessionStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'aartha_session';
  final FlutterSecureStorage _storage;

  @override
  Future<AuthSession?> read() async =>
      AuthSession.tryDecode(await _storage.read(key: _key));

  @override
  Future<void> write(AuthSession session) =>
      _storage.write(key: _key, value: session.encode());

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
