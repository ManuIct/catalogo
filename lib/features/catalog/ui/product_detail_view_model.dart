import '../../../base/config/errors/app_exception.dart';
import '../../../base/viewmodel/base_view_model.dart';
import '../domain/model/product.dart';
import '../domain/repository/product_repository.dart';

class ProductDetailViewModel extends BaseViewModel {
  ProductDetailViewModel(this._repository, this.id);
  final ProductRepository _repository;
  final int id;

  Product? _product;
  bool _isLoading = false;
  String? _error;

  Product? get product => _product;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notify();

    try {
      _product = await _repository.getById(id);
    } on AppException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Errore imprevisto.';
    }

    _isLoading = false;
    notify();
  }
}
