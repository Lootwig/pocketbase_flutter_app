class Config {
  static const baseUrl = String.fromEnvironment(
    'baseUrl',
    defaultValue: 'http://127.0.0.1:8090',
  );

  static const skipLogin = true;

  static const testEmail = String.fromEnvironment('testEmail');
  static const testPassword = String.fromEnvironment('testPassword');
}
