import 'package:fisly_mobile/core/ui/theme/fisly_colors.dart';
import 'package:fisly_mobile/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';

ThemeData fislyTheme() {
  return ThemeData(
    fontFamily: 'Inter',
    scaffoldBackgroundColor: FislyColors.background,
    primaryColor: FislyColors.primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: FislyColors.surface,
      elevation: 0,
      foregroundColor: FislyColors.textPrimary,
      centerTitle: true,
    ),
    dividerColor: FislyColors.divider,
    elevatedButtonTheme: ElevatedButtonThemeData(style: FislyButtons.primary),
    outlinedButtonTheme: OutlinedButtonThemeData(style: FislyButtons.secondary),
  );
}
