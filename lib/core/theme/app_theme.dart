import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF00796B); // Deep Teal
  static const Color secondaryColor = Color(0xFF4DB6AC); // Light Teal
  static const Color backgroundColor = Color(0xFFFDFBF7); // Cream/Off-white
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color textColor = Color(
    0xFF1F2937,
  ); // Darker Grey for better contrast
  static const Color subtitleColor = Color(0xFF6B7280); // Cool Grey
  static const Color inputFillColor = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
        error: errorColor,
        surfaceContainerLowest: Colors.white,
      ),

      // Typography
      textTheme: GoogleFonts.tajawalTextTheme()
          .apply(bodyColor: textColor, displayColor: textColor)
          .copyWith(
            displayLarge: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: textColor,
            ),
            displayMedium: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: textColor,
            ),
            titleLarge: GoogleFonts.tajawal(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: textColor,
            ),
            bodyLarge: GoogleFonts.tajawal(fontSize: 16, color: textColor),
            bodySmall: GoogleFonts.tajawal(
              fontSize: 14,
              color: subtitleColor,
              fontWeight: FontWeight.w500,
            ),
          ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textColor),
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          textStyle: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        hintStyle: TextStyle(
          color: Colors.grey.withValues(alpha: 0.6),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none, // Clean look by default
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
      ),
    );
  }
}
