import 'package:flutter/material.dart';

class AppTheme {
  // Color palette
  static const Color primaryColor = Color(0xFF2563EB); // Blue-600
  static const Color primaryVariant = Color(0xFF1D4ED8); // Blue-700
  static const Color secondaryColor = Color(0xFF10B981); // Emerald-500
  static const Color errorColor = Color(0xFFEF4444); // Red-500
  static const Color warningColor = Color(0xFFF59E0B); // Amber-500
  static const Color successColor = Color(0xFF10B981); // Emerald-500

  // Neutral colors
  static const Color surfaceColor = Color(0xFFFAFAFA); // Gray-50
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFE5E7EB); // Gray-200

  // Text colors
  static const Color primaryTextColor = Color(0xFFABC7FF); // Gray-900
  static const Color secondaryTextColor = Color(0xFF6B7280); // Gray-500
  static const Color hintTextColor = Color(0xFF9CA3AF); // Gray-400

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: Color(0xFFDEEAFF), // Light blue
        secondary: secondaryColor,
        secondaryContainer: Color(0xFFD1FAE5), // Light emerald
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: primaryTextColor,
        onBackground: primaryTextColor,
        onError: Colors.white,
        outline: dividerColor,
        outlineVariant: Color(0xFFF3F4F6), // Gray-100
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: backgroundColor,
        foregroundColor: primaryTextColor,
        titleTextStyle: TextStyle(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: primaryTextColor, size: 24),
      ),

      // Text Field Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        // Border styles
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        // Text styles
        hintStyle: const TextStyle(
          color: hintTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: secondaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),

        // Error style
        errorStyle: const TextStyle(
          color: errorColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),

        // Constraints
        constraints: const BoxConstraints(minHeight: 56),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              elevation: 2,
              shadowColor: primaryColor.withOpacity(0.3),
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Color(0xFFE5E7EB),
              disabledForegroundColor: Color(0xFF9CA3AF),

              // Shape
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              // Padding
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

              // Minimum size
              minimumSize: const Size(120, 56),

              // Text style
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ).copyWith(
              // Hover and pressed states
              overlayColor: MaterialStateProperty.resolveWith<Color?>((
                Set<MaterialState> states,
              ) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.white.withOpacity(0.1);
                }
                if (states.contains(MaterialState.pressed)) {
                  return Colors.white.withOpacity(0.2);
                }
                return null;
              }),
              backgroundColor: MaterialStateProperty.resolveWith<Color?>((
                Set<MaterialState> states,
              ) {
                if (states.contains(MaterialState.disabled)) {
                  return const Color(0xFFE5E7EB);
                }
                if (states.contains(MaterialState.pressed)) {
                  return primaryVariant;
                }
                return primaryColor;
              }),
            ),
      ),

      // Text Button Theme (for secondary actions)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(120, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: primaryTextColor, size: 24),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(color: primaryColor, size: 24),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: primaryTextColor,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: primaryTextColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: primaryTextColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: primaryTextColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: secondaryTextColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: primaryTextColor,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: primaryTextColor,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: primaryTextColor,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Scaffold Background
      scaffoldBackgroundColor: backgroundColor,

      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // Dark theme variant
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF60A5FA), // Lighter blue for dark theme
        primaryContainer: Color(0xFF1E3A8A),
        secondary: Color(0xFF34D399), // Lighter emerald
        secondaryContainer: Color(0xFF065F46),
        surface: Color(0xFF1F2937), // Gray-800
        background: Color(0xFF111827), // Gray-900
        error: Color(0xFFF87171), // Lighter red
        onPrimary: Color(0xFF111827),
        onSecondary: Color(0xFF111827),
        onSurface: Color(0xFFF9FAFB), // Gray-50
        onBackground: Color(0xFFF9FAFB),
        onError: Color(0xFF111827),
        outline: Color(0xFF4B5563), // Gray-600
        outlineVariant: Color(0xFF374151), // Gray-700
      ),
      scaffoldBackgroundColor: const Color(0xFF111827),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF111827),
        foregroundColor: Color(0xFFF9FAFB),
      ),
      inputDecorationTheme: lightTheme.inputDecorationTheme?.copyWith(
        fillColor: const Color(0xFF375785),
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        labelStyle: const TextStyle(color: Color(0xFFD1D5DB)),
      ),
    );
  }
}
