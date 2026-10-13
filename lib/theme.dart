import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2E7D6F);
  static const primaryLight = Color(0xFF6DB3A6);
  static const bg = Color(0xFFF5F7F7);
  static const income = Color(0xFF2E9E5B);
  static const expense = Color(0xFFE5484D);
  static const textDark = Color(0xFF1C1C1C);
  static const textGrey = Color(0xFF8A8F94);
  static const border = Color(0xFFDADFE2);
}

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
