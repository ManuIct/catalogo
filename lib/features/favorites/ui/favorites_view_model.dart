import 'package:flutter/foundation.dart';

import '../../catalog/domain/model/product.dart';

class FavoritesViewModel extends ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(int productId) {
    return _favorites.any((p) => p.id == productId);
  }

  void toggle(Product product) {
    if (isFavorite(product.id)) {
      _favorites.removeWhere((p) => p.id == product.id);
    }
    _favorites.add(product);
  }
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
