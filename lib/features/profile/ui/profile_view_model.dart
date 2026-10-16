// ignore_for_file: unused_import

import '../../../base/config/errors/app_exception.dart';
import '../../../base/viewmodel/base_view_model.dart';
import '../../auth/domain/repository/auth_repository.dart';
import '../domain/repository/profile_repository.dart';

class ProfileViewModel extends BaseViewModel {
  ProfileViewModel(this._profileRepo, this._authRepo);
  final ProfileRepository _profileRepo;
  final AuthRepository _authRepo;

  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notify();

    try {
      _user = await _profileRepo.getProfile();
    } on AppException catch (e) {
      _error = 'Errore nel caricamento del profilo';
    }

    _isLoading = false;
    notify();
  }

  Future<void> logout() async {
    await _authRepo.logout();
  }
}