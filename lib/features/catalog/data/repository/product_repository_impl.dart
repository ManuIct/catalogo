import '../../../../base/network/dio_error_mapper.dart';
import '../../domain/model/product.dart';
import '../../domain/repository/product_repository.dart';
import '../source/product_remote_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._remote);

  final ProductRemoteSource _remote;

  @override
  Future<List<Product>> getProducts() => guardDio<List<Product>>(() async {
        final models = await _remote.fetchProducts();
        return models.map((m) => m.toEntity()).toList();
      });

  @override
  Future<List<Product>> search(String query) =>
      guardDio<List<Product>>(() async {
        final models = await _remote.search(query);
        return models.map((m) => m.toEntity()).toList();
      });

  @override
  Future<Product> getById(int id) => guardDio<Product>(() async {
        final model = await _remote.fetchById(id);
        return model.toEntity();
      });
}