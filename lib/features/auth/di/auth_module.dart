// ignore_for_file: unused_import

import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../base/session/session_notifier.dart';
import '../../../base/storage/token_store.dart';
import '../data/respository/auth_repostory_impl.dart';
import '../data/source/auth_remote_source.dart';
import '../domain/repository/auth_repository.dart';

List<SingleChildWidget> authProviders() => [
    Provider<AuthRemoteSource>(
      create: (ctx) => AuthRemoteSource(ctx.read<Dio>()),
      ),
      Provider<AuthRepository>(
        create: (ctx) => AuthRepostoryImpl(
          remote: ctx.read<AuthRemoteSource>(),
          tokenStore: ctx.read<TokenStore>(),
          session: ctx.read<SessionNotifier>()
          ),
        ),
];