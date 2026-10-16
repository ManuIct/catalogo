import 'package:catalogo/features/profile/domain/repository/data/source/profile_remote_source.dart';

import '../../domain/repository/profile_repository.dart';
import '../source/profile_remote_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remote);
  final ProfileRemoteSource _remote;

  @override
  Future<Map<String, dynamic>> getProfile() => _remote.fetchProfile();
}