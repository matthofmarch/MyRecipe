class EnvironmentConfig{
  static const ENVIRONMENT = String.fromEnvironment('ENVIRONMENT', defaultValue: 'Development');
  static const API_BASE_URL = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:5000');
}