import 'auth_failure.dart';

/// The three roles in the system (BR-02).
enum UserRole { investor, broker, administrator }

/// What the backend tells the app after a successful sign in.
///
/// BR-08: the role (and ids) come from the authenticated response, never from
/// anything the client supplies, so screens must read them from here.
class AuthSession {
  const AuthSession({
    required this.username,
    required this.role,
    required this.displayName,
    this.clientId,
    this.brokerCode,
  });

  final String username;
  final UserRole role;
  final String displayName;

  /// Set for investors (BR-05).
  final String? clientId;

  /// Set for brokers (BR-06).
  final String? brokerCode;
}

/// TODO: replace with the real call to the Django backend (token auth).
///
/// Demo accounts:
///  * `investor` : active investor
///  * `broker`   : active broker (broker area is built later)
///  * `inactive` : inactive investor, rejected (BR-07)
///  * `admin`    : administrator, rejected here because admins use Django
///    Admin (BR-A01)
/// Any other username is treated as wrong credentials (BR-01, BR-I01).
abstract final class DemoAuthBackend {
  static Future<AuthSession> authenticate(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    switch (username.trim().toLowerCase()) {
      case 'investor':
      case 'demo':
        return const AuthSession(
          username: 'investor',
          role: UserRole.investor,
          displayName: 'Aarav Sharma',
          clientId: 'C001',
        );
      case 'broker':
        return const AuthSession(
          username: 'broker',
          role: UserRole.broker,
          displayName: 'Broker name',
          brokerCode: 'B001',
        );
      case 'inactive':
        throw const AuthFailure(
          'This account is inactive. Contact your broker to reactivate it.',
        );
      case 'admin':
        throw const AuthFailure(
          'Administrators sign in through the admin portal.',
        );
      default:
        throw const AuthFailure(
          'Incorrect username or password. Contact your broker if you need help.',
        );
    }
  }
}
