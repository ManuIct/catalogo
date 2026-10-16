import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base/network/dio_factory.dart';
import '../base/router/app_router.dart';
import '../base/session/session_notifier.dart';
import '../base/storage/token_store.dart';
import 'package:provider/single_child_widget.dart';
import '../features/auth/data/source/token_refresh_source.dart';
import '../features/auth/di/auth_module.dart';
import '../features/catalog/di/catalog_module.dart';
import '../features/favorites/di/favorites_module.dart';
import '../features/profile/di/profile_module.dart';
import '../features/theme/di/theme_module.dart';

List<SingleChildWidget> buildAppProviders(SharedPreferences prefs) {
  return [
    // Local Storage & Core Session
    Provider<SharedPreferences>.value(value: prefs),

    ChangeNotifierProvider<SessionNotifier>(
      create: (_) => SessionNotifier(),
    ),

    Provider<TokenStore>(
      create: (_) => SecureTokenStore(const FlutterSecureStorage()),
    ),

    // Network Layer
    Provider<TokenRefreshSource>(
      create: (_) => TokenRefreshSource(createBareDio()),
    ),

    Provider<Dio>(
      create: (ctx) => createAuthedDio(
        tokenStore: ctx.read<TokenStore>(),
        refresh: ctx.read<TokenRefreshSource>().refresh,
        onSessionExpired: ctx.read<SessionNotifier>().markAuthenticated,
      ),
    ),

    // Feature Modules Spread
    ...authProviders(),
    ...catalogProviders(),
    ...profileProviders(),
    ...favoritesProviders(),
    ...themeProviders(),

    // Router Provider
    Provider<GoRouter>(
      create: (ctx) => buildRouter(session: ctx.read<SessionNotifier>()),
      dispose: (_, router) => router.dispose(),
    ),
  ];
}