// ignore_for_file: unused_import

import 'package:dio/dio.dart';

import '../../../../base/network/auth_options.dart';
import 'package:catalogo/features/catalog/data/model/product_model.dart';

class ProductRemoteSource {
  ProductRemoteSource(this._dio);

  final Dio _dio;

  Future<List<ProductModel>> fetchProducts() async {
    final response = await _dio.get<Map<String, dynamic>>(
       '/auth/products',
       queryParameters: {'limit' : 30},
       options: AuthOptions.protected(),
      );
      return _parseList(response.data!);
  }

  Future<List<ProductModel>> search(String query) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/products/search',
      queryParameters: {'q' : query},
      );
      return _parseList(response.data!);
  }

  Future<ProductModel> fetchById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/products/$id');
    return ProductModel.fromJson(response.data!);
  }

  List<ProductModel> _parseList(Map<String, dynamic> data) {
    final list = data['products'] as List<dynamic>;
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}