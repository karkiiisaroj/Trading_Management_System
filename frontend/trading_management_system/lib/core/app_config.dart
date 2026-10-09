/// Build-time configuration. Override with --dart-define, e.g.
///   flutter run --dart-define=API_BASE_URL=https://api.example.com/api
abstract final class AppConfig {
  /// Base URL of the backend API, no trailing slash.
  /// Note: Android emulators reach the host machine at 10.0.2.2, not localhost.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api',
  );

  /// Login endpoint, appended to [apiBaseUrl].
  static const loginPath = String.fromEnvironment(
    'API_LOGIN_PATH',
    defaultValue: '/auth/login/',
  );
}
