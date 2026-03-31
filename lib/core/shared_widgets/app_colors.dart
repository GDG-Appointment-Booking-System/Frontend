import 'package:flutter/material.dart';

class AppColors {
  // --- BRAND COLORS ---
  // The dominant dark navy used for buttons, active states, and heavy text.
  static const Color primary = Color(0xFF0F172A); 
  
  // The premium accent color used for "Most Popular", star ratings, and prices.
  // It's a muted, sophisticated bronze/gold.
  static const Color accentGold = Color(0xFFB8977E);

  // --- BACKGROUND & SURFACE ---
  // The main background of the app. It is NOT pure white, it's a very soft gray
  // to make the pure white cards pop out.
  static const Color background = Color(0xFFF4F6F8);
  
  // Used for Cards, Bottom Navigation Bar, and input fields.
  static const Color surface = Color(0xFFFFFFFF);

  // --- TYPOGRAPHY ---
  // Main headers and important text. (Almost black/dark navy)
  static const Color textMain = Color(0xFF1E293B);
  
  // Secondary text, descriptions, times, and unselected icons.
  static const Color textMuted = Color(0xFF64748B);
  
  // Text used on top of primary dark buttons (Pure White)
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // --- UTILITY / STATUS ---
  // Used for borders, dividers, and inactive states.
  static const Color borderSubtle = Color(0xFFE2E8F0);
  
  // Used for "Cancel" buttons or error states.
  static const Color error = Color(0xFFEF4444);
  
  // Used for success states (if needed, though the design leans on primary)
  static const Color success = Color(0xFF10B981);
}
