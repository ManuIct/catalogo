// ignore_for_file: unused_catch_clause, prefer_final_fields, unused_field, unused_import

import 'package:catalogo/base/config/errors/app_exception.dart';

import '../../../base/errors/app_exception.dart';
import '../../../base/viewmodel/base_view_model.dart';
import '../domain/repository/auth_repository.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel(this._auth);

  final AuthRepository _auth;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notify();

    try {
      await _auth.login(username: username.trim(), password: password);
    } on AppException catch (e) {
      _error = 'Errore imprevisto. Riprova.';
    }

    _isLoading = false;
    notify();
  }
  
}