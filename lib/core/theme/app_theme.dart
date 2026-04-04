import 'package:flutter/material.dart';
import '../shared_widgets/app_colors.dart';

final ThemeData sharpCutTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    secondary: AppColors.accentGold,
    onSecondary: AppColors.primary,
    error: AppColors.error,
    onError: AppColors.textOnPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textMain,
  ),

  // Keep typography simple and readable for beginner teams.
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: AppColors.textMain,
      fontWeight: FontWeight.w700,
      height: 1.2,
    ),
    headlineMedium: TextStyle(
      color: AppColors.textMain,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      color: AppColors.textMain,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: AppColors.textMain,
      fontWeight: FontWeight.w600,
    ),
    displayLarge: TextStyle(
      color: AppColors.textMain,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(color: AppColors.textMain, height: 1.4),
    bodyMedium: TextStyle(color: AppColors.textMuted),
    labelLarge: TextStyle(fontWeight: FontWeight.w600),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textMain,
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),

  // Primary action buttons.
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    ),
  ),

  // Secondary actions such as "View History" or "Cancel".
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.textMain,
      minimumSize: const Size.fromHeight(48),
      side: const BorderSide(color: AppColors.borderSubtle),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    ),
  ),

  // Global card style used by all list/detail sections.
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shadowColor: Colors.transparent,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: AppColors.borderSubtle),
    ),
  ),

  // Input fields for login and forms.
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    labelStyle: const TextStyle(color: AppColors.textMuted),
    hintStyle: const TextStyle(color: AppColors.textMuted),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.borderSubtle),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.borderSubtle),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
    ),
  ),

  chipTheme: const ChipThemeData(
    backgroundColor: AppColors.primarySoft,
    labelStyle: TextStyle(color: AppColors.textMain),
    side: BorderSide(color: AppColors.borderSubtle),
    shape: StadiumBorder(),
    selectedColor: AppColors.primary,
    secondaryLabelStyle: TextStyle(color: AppColors.textOnPrimary),
  ),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.surface,
    indicatorColor: AppColors.primarySoft,
    labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
      final isSelected = states.contains(WidgetState.selected);
      return TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textMuted,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      );
    }),
  ),

  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.primary,
    contentTextStyle: const TextStyle(color: AppColors.textOnPrimary),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);
