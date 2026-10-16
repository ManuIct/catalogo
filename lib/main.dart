import 'package:catalogo/di/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_provider.dart' hide buildAppProviders;
import 'base/theme/app_theme.dart';
import 'features/theme/ui/theme_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildAppProviders(prefs),
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVm, _) {
          return MaterialApp.router(
            title: 'Catalogo',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeVm.themeMode,
            routerConfig: context.read<GoRouter>(),
          );
        },
      ),
    );
  }
}