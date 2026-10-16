import 'dart:async';

import '../../../base/config/errors/app_exception.dart';
import '../../../base/viewmodel/base_view_model.dart';
import '../domain/model/product.dart';
import '../domain/repository/product_repository.dart';

class CatalogViewModel extends BaseViewModel {
  CatalogViewModel(
    this._repository, {
    Duration debounce = const Duration(milliseconds: 400),
  }) : _debounceDuration = debounce;

  final ProductRepository _repository;
  final Duration _debounceDuration;

  List<Product> _products = const [];
  bool _isLoading = false;
  String? _error;
  String _query = '';

  Timer? _debounceTimer;
  int _requestId = 0;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() => _fetch(_query);

  void onQueryChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      _query = value.trim();
      _fetch(_query);
    });
  }

  Future<void> _fetch(String query) async {
    final requestId = ++_requestId;
    _isLoading = true;
    _error = null;
    notify();

    try {
      final result = query.isEmpty
          ? await _repository.getProducts()
          : await _repository.search(query);

      if (requestId != _requestId) return;
      _products = result;
    } on AppException catch (e) {
      if (requestId != _requestId) return;
      _error = e.message;
    } catch (_) {
      if (requestId != _requestId) return;
      _error = 'Errore imprevisto. Riprova.';
    }

    if (requestId != _requestId) return;
    _isLoading = false;
    notify();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}