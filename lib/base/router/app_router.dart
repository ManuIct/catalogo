import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:catalogo/features/auth/domain/repository/auth_repository.dart';
import 'package:catalogo/features/auth/ui/login_page.dart';
import 'package:catalogo/features/auth/ui/login_view_model.dart';
import 'package:catalogo/features/auth/ui/splash_page.dart';
import 'package:catalogo/features/catalog/domain/repository/product_repository.dart';
import 'package:catalogo/features/catalog/ui/catalog_page.dart';
import 'package:catalogo/features/catalog/ui/catalog_view_model.dart';
import 'package:catalogo/features/catalog/ui/product_detail_page.dart';
import 'package:catalogo/features/catalog/ui/product_detail_view_model.dart';
import 'package:catalogo/features/favorites/ui/favorites_page.dart';
import 'package:catalogo/features/profile/domain/repository/profile_repository.dart';
import 'package:catalogo/features/profile/ui/profile_page.dart';
import 'package:catalogo/features/profile/ui/profile_view_model.dart';
import 'package:catalogo/base/session/session_notifier.dart';

class AppRoutes {
  const AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const catalog = '/catalogo';
  static const profile = '/profilo';
  static const favorites = '/preferiti';
  static const productPattern = '/prodotto/:id';
}

GoRouter buildRouter({required SessionNotifier session}) {
  return GoRouter(
    initialLocation: AppRoutes.catalog,
    refreshListenable: session,
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (session.status == SessionStatus.unknown) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final isLoggedIn = session.isAuthenticated;
      if (!isLoggedIn) {
        return location == AppRoutes.login ? null : AppRoutes.login;
      }

      if (location == AppRoutes.login || location == AppRoutes.splash) {
        return AppRoutes.catalog;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => ChangeNotifierProvider(
          create: (ctx) => LoginViewModel(ctx.read<AuthRepository>()),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.catalog,
        builder: (context, state) => ChangeNotifierProvider(
          create: (ctx) =>
              CatalogViewModel(ctx.read<ProductRepository>())..loadProducts(),
          child: const CatalogPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.productPattern,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');

          if (id == null) {
            // ID non valido → mostra il catalogo come fallback
            return ChangeNotifierProvider(
              create: (ctx) => CatalogViewModel(
                ctx.read<ProductRepository>(),
              )..loadProducts(),
              child: const CatalogPage(),
            );
          }

          return ChangeNotifierProvider(
            create: (ctx) => ProductDetailViewModel(
              ctx.read<ProductRepository>(),
              id,
            )..load(),
            child: const ProductDetailPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => ChangeNotifierProvider(
          create: (ctx) => ProfileViewModel(
            ctx.read<ProfileRepository>(),
            ctx.read<AuthRepository>(),
          )..load(),
          child: const ProfilePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        builder: (context, state) => const FavoritesPage(),
      ),
    ],
  );
}