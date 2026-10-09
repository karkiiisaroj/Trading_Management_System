import 'package:flutter/foundation.dart';

import 'auth_models.dart';
import 'auth_repository.dart';
import 'session_store.dart';

enum AuthStatus { unknown, signedOut, signedIn }

class AuthController extends ChangeNotifier {
  AuthController({required this.repository, required this.store});

  final AuthRepository repository;
  final SessionStore store;

  AuthStatus _status = AuthStatus.unknown;
  AuthSession? _session;

  AuthStatus get status => _status;
  AuthSession? get session => _session;

  /// Called once at startup: resume a saved session if there is one.
  Future<void> restore() async {
    try {
      _session = await store.read();
    } catch (_) {
      _session = null; // unreadable keystore -> just ask for a login
    }
    _status = _session == null ? AuthStatus.signedOut : AuthStatus.signedIn;
    notifyListeners();
  }

  /// Throws [AuthException] on failure (shown on the login form).
  Future<void> signIn(String username, String password) async {
    final session = await repository.login(username, password);
    try {
      await store.write(session);
    } catch (_) {
      // Couldn't persist: still signed in for this run.
    }
    _session = session;
    _status = AuthStatus.signedIn;
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await store.clear();
    } catch (_) {}
    _session = null;
    _status = AuthStatus.signedOut;
    notifyListeners();
  }
}
