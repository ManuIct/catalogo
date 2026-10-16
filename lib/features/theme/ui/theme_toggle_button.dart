import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme_view_model.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVm = context.watch<ThemeViewModel>();

    return IconButton(
      tooltip: 'Cambia tema',
      onPressed: () => themeVm.toggleTheme(),
      icon: Icon(
        themeVm.isDark ? Icons.light_mode : Icons.dark_mode,
      ),
    );
  }
}

