class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = 'https://dummyjson.com';

  static const int tokenLifetimeMinutes = 1;

  static const Duration timeout = Duration(seconds: 15);
}
