// ignore_for_file: unused_import

import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../storage/token_store.dart';
import 'auth_interceptor.dart';

Dio createBareDio() {
  return Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
    ),
  );
}

Dio createAuthedDio({
  required TokenStore tokenStore,
  required TokenRefresher refresh,
  required void Function() onSessionExpired,
}) {
  final dio = createBareDio();
  dio.interceptors.add(
    AuthInterceptor(
      dio: dio,
      tokenStore: tokenStore,
      refresh: refresh,
      onSessionExpired: onSessionExpired,
    ),
  );
  return dio;
}
