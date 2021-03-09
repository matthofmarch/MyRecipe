class EnvironmentConfig {
  static const ENVIRONMENT = String.fromEnvironment('ENVIRONMENT');
  static const API_BASE_URL = String.fromEnvironment('API_BASE_URL');
  static const ALLOW_BAD_CERTIFICATE =
      bool.fromEnvironment('ALLOW_BAD_CERTIFICATE', defaultValue: false);
}
