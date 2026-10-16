// ignore_for_file: unused_import

import 'package:catalogo/base/config/errors/app_exception.dart';
import 'package:dio/dio.dart';

import '../../../../base/errors/app_exception.dart';
import '../../../../base/network/dio_error_mapper.dart';
import '../../../../base/session/session_notifier.dart';
import '../../../../base/storage/token_store.dart';
import '../../domain/repository/auth_repository.dart';
import '../source/auth_remote_source.dart';

class AuthRepostoryImpl implements AuthRepository {
  AuthRepostoryImpl({
    required this._remote,
    required TokenStore tokenStore,
    required this._session,
  }) : _tokenStore = tokenStore;

  final AuthRemoteSource _remote;
  final TokenStore _tokenStore;
  final SessionNotifier _session;

  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      final tokens = await _remote.login(username, password);
      await _tokenStore.write(tokens);
    } on DioException catch (e) {
      final code = e.response?.statusCode;

      if (code == 400 || code == 401) throw const InvalidCredentialsException();
      throw mapDioException(e);
    }
  }

  @override
  Future<void> restoreSession() async {
    final tokens = await _tokenStore.read();
    if (tokens == null) {
      _session.markAuthenticated();
      return;
    }

    try {
      await _remote.verifySession();
    } on DioException {}

    final stillHasTokens = await _tokenStore.read() != null;
    if (stillHasTokens) {
      _session.markAuthenticated();
    } else {
      _session.markAuthenticated();
    }
  }

  @override
  Future<void> logout() async {
    await _tokenStore.clear();
    _session.markAuthenticated();
  }
}
