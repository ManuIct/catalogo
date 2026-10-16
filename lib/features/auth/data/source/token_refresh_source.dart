// ignore_for_file: unused_import

import 'package:dio/dio.dart';

import '../../../../base/config/api_config.dart';
import '../../../../base/storage/token_store.dart';

class TokenRefreshSource {
  TokenRefreshSource(this._bareDio);

  final Dio _bareDio;

  Future<AuthTokens?> refresh(String refreshToken) async {
    try {
      final response = await _bareDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {
          'refreshToken' : refreshToken,
          'expiresInMins' : ApiConfig.tokenLifetimeMinutes,
        },
        );
        final data = response.data!;
        return AuthTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: (data['refreshToken'] as String?) ?? refreshToken,
          );
      
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 400 || code == 401 || code == 403) return null;
      rethrow;
    }
  }
}