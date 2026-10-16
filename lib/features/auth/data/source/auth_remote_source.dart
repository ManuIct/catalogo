// ignore_for_file: unused_field, unused_import

import 'package:dio/dio.dart';

import '../../../../base/config/api_config.dart';
import '../../../../base/network/auth_options.dart';
import '../../../../base/storage/token_store.dart';

class AuthRemoteSource {
  AuthRemoteSource(this._dio);

  final Dio _dio;

  Future<AuthTokens> login(String username, String password) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'username' : username,
        'password' : password,
        'expiresInMins' : ApiConfig.tokenLifetimeMinutes,
      },
    );
    final data = response.data!;
    return AuthTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      );
  }

  Future<void> verifySession() async {
    await _dio.get<dynamic>('/auth/me', options: AuthOptions.protected());
  }
}

