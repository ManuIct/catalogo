import 'package:catalogo/base/network/auth_options.dart';
import 'package:dio/dio.dart';
import '../../../../base/network/auth_options.dart';

class ProfileRemoteSource {
  ProfileRemoteSource(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> fetchProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/auth/me',
      options: AuthOptions.protected(),
      );
      return response.data!;
  }
}