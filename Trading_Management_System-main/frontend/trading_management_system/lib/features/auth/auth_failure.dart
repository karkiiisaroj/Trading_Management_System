/// Thrown by a sign-in callback when the server rejects the credentials.
/// [message] is shown to the user as-is.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => 'AuthFailure: $message';
}
