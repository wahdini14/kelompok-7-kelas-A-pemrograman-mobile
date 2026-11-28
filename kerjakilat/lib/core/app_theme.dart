import 'package:flutter/material.dart';

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