import 'package:catalogo/features/theme/ui/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'base/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  ThemeMode? get themeMode => null;

  @override
  Widget build(BuildContext context) {
    final router = context.read<GoRouter>();

    final themMode = context.watch<ThemeViewModel>().mode;

    return MaterialApp.router(
      title: 'Catalogo Flutter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}