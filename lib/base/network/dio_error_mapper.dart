import 'package:dio/dio.dart';
import '../config/errors/app_exception.dart';

AppException mapDioException(DioException e) {
  final isNetworkProblem = e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout;
  if (isNetworkProblem) return const NetworkException();

  final code = e.response?.statusCode;
  if (code == 401) return const SessionExpiredException();
  return ServerException(code);
}

Future<T> guardDio<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on DioException catch (e) {
    throw mapDioException(e);
  }
}