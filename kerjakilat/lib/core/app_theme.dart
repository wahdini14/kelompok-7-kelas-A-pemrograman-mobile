import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// Tema umum aplikasi.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seeker),
        scaffoldBackgroundColor: AppColors.background,
      );
}