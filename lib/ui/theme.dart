import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Cinematic Dark Theme
  static const Color background = Color(0xFF050505);
  static const Color cardColor = Color(0xFF1C1C1E);
  static const Color accent = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF8E8E93);
  static const Color divider = Color(0xFF2C2C2E);

  // Translucent colors for glass effects
  static final Color glassBackground = const Color(0xFF1C1C1E).withOpacity(0.6);
  static final Color glassBorder = const Color(0xFFFFFFFF).withOpacity(0.1);
}

class AppTextStyles {
  static final TextStyle header = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
    letterSpacing: -0.5,
  );

  static final TextStyle title = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
  );

  static final TextStyle body = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary,
  );

  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary.withOpacity(0.8),
  );

  static final TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.accent,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.background,
      fontFamily: GoogleFonts.inter().fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.secondary,
        surface: AppColors.cardColor,
        onSurface: AppColors.accent,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.accent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.accent,
        ),
      ),
    );
  }
}
