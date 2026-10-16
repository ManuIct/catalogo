import 'package:dio/dio.dart';

import '../storage/token_store.dart';
import 'auth_options.dart';

typedef TokenRefresher = Future<AuthTokens?> Function(String refreshToken);

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.dio,
    required this.tokenStore,
    required this.refresh,
    required this.onSessionExpired,
  });
  
  final Dio dio;
  final TokenStore tokenStore;
  final TokenRefresher refresh;

  final void Function() onSessionExpired;

  Future<AuthTokens?>? _refreshInFlight;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[requiresAuthkey] == true) {
      final tokens = await tokenStore.read();
      if (tokens != null) {
        options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      }
      
    }
    handler.next(options);
  }

    @override
    Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
    ) async {
      final request = err.requestOptions;
      final isProtected = request.extra[requiresAuthkey] == true;
      final alreadyRetried = request.extra[retriedKey] == true;

      if (err.response?.statusCode != 401 || !isProtected || alreadyRetried) {
          handler.next(err);
          return;
      }

     final stored = await tokenStore.read();
     if (stored == null) {
       onSessionExpired();
       handler.next(err);
       return;
     }

     final usedHeader = request.headers['Authorization'];
     final alreadyRenewed = usedHeader != 'Bearer ${stored.accessToken}';


        try {
          if (!alreadyRenewed) {
            final renewed = await _refreshOnce(stored.refreshToken);
            if(renewed == null) {
              await tokenStore.clear();
              onSessionExpired();
              handler.next(err);
              return;
            }
          }
          final retryOptions = request.copyWith(
              extra: {...request.extra, retriedKey: true},
          );
          final response = await dio.fetch<dynamic>(retryOptions);
          handler.resolve(response);
        } on DioException catch (e) {
          handler.next(e);
        }
    }

    Future<AuthTokens?> _refreshOnce(String refreshToken) {
      return _refreshInFlight ??= _doRefresh(refreshToken).whenComplete(() {
        _refreshInFlight = null;
      });
    }

    Future<AuthTokens?> _doRefresh(String refreshToken) async {
      final tokens = await refresh(refreshToken);
      if (tokens != null) {
        await tokenStore.write(tokens);
      }
      return tokens;
    }
}