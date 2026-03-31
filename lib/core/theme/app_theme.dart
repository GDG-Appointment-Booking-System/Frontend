import 'package:flutter/material.dart';
import '../shared_widgets/app_colors.dart';

final ThemeData sharpCutTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,

  // Makes all default Text look like the mockup
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: AppColors.textMain,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(color: AppColors.textMain),
    bodyMedium: TextStyle(color: AppColors.textMuted),
  ),

  // Makes all standard ElevatedButtons look like the "Book Now" buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary, // Text color on button
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners from mockup
      ),
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  ),

  // Global styling for the white cards
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.05),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  
);
