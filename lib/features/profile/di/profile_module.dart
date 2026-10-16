import 'package:catalogo/features/profile/data/repository/profile_repository_impl.dart';
import 'package:catalogo/features/profile/domain/repository/data/source/profile_remote_source.dart';
import 'package:catalogo/features/profile/domain/repository/profile_repository.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> profileProviders() {
  return [
   Provider<ProfileRemoteSource>(
    create: (ctx) => ProfileRemoteSource(ctx.read<Dio>())
    ),
    Provider<ProfileRepository>(
      create: (ctx) => ProfileRepositoryImpl(ctx.read<ProfileRemoteSource>()),
      ),
  ];
}
