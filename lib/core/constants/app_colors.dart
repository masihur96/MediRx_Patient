import 'package:flutter/material.dart';

/// Consolidated Design System Color Palette for MediRx Patient
class AppColors {
  AppColors._();

  // Primary Healthcare Brand Colors
  static const Color primaryTeal = Color(0xFF0F7A7A); // Dark Teal
  static const Color lightTeal = Color(0xFF159A9C);   // Lighter Teal
  static const Color mint = Color(0xFFE0F2F1);
  static const Color gradientTop = Color(0xFFE0F7FA);
  static const Color gradientBottom = Color(0xFFFFFFFF);
  static const Color inputBackground = Color(0xFFF5F5F5);

  // Functional & Action Colors
  static const Color buttonPrimary = primaryTeal;
  static const Color buttonSecondary = lightTeal;
  static const Color errorRed = Color(0xFFE57373);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color infoBlue = Color(0xFF2196F3);

  // Neutral Palette (Light Mode)
  static const Color backgroundLight = Colors.white;
  static const Color surfaceLight = Colors.white;
  static const Color textDark = Color(0xFF212121);
  static const Color textGray = Color(0xFF757575);
  static const Color darkGrey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Neutral Palette (Dark Mode)
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFEEEEEE);

  // Shadows
  static const Color cardShadow = Color(0x1A000000);
}
