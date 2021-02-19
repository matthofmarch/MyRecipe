class EnvironmentConfig {
  static const ENVIRONMENT =
      String.fromEnvironment('ENVIRONMENT', defaultValue: 'Development');
  static const API_BASE_URL = String.fromEnvironment('API_BASE_URL',
      defaultValue: 'http://localhost:5000');
  static const ALLOW_BAD_CERTIFICATE =
      bool.fromEnvironment('ALLOW_BAD_CERTIFICATE', defaultValue: false);
}
