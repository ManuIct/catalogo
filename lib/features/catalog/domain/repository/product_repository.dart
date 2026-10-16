import '../model/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();

  Future<List<Product>> search(String query);

  Future<Product> getById(int id);
}