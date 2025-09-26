import 'package:flutter/material.dart';

class AppConsts {
  static const String logoPath = 'lib/assets/logo.png';

  // === BRAND COLORS (Preserved) ===
  static const primaryColor =
      Color.fromRGBO(45, 77, 50, 1); // Original brand green
  static const secondaryColor = Color(0xFFFFD700); // Original brand gold

  // === ENHANCED COLOR PALETTE ===
  // Primary color variations
  static const primaryColorLight =
      Color(0xFF5A9960); // Lighter green for hover states
  static const primaryColorDark = Color(0xFF1B3A1E); // Darker green for depth
  static const primaryColorAccent =
      Color(0xFF3D6B42); // Medium green for active states

  // Secondary color variations
  static const secondaryColorLight =
      Color(0xFFFFF176); // Light gold for subtle highlights
  static const secondaryColorDark =
      Color(0xFFDAA520); // Darker gold for better contrast
  static const secondaryColorAccent =
      Color(0xFFFDD835); // Vibrant gold for important elements

  // === NEUTRAL COLORS (Accessible) ===
  static const surfaceColor = Color(0xFF2C4A30); // Green-tinted surface
  static const surfaceColorLight =
      Color(0xFF3A5F3E); // Lighter surface for cards
  static const surfaceColorDark = Color(0xFF1E3522); // Darker surface for depth

  // Background colors
  static const backgroundColor =
      Color(0xFF1A2E1D); // Very dark green background
  static const backgroundColorAlt = Color(0xFF243528); // Alternative background

  // Text colors (WCAG compliant)
  static const textColorPrimary =
      Color(0xFFFFFFFF); // Pure white for high contrast
  static const textColorSecondary =
      Color(0xFFE8F5E8); // Slightly green-tinted white
  static const textColorTertiary =
      Color(0xFFB8D4BA); // Light green for less important text
  static const textColorMuted =
      Color(0xFF8FA091); // Muted green for disabled text

  // === SEMANTIC COLORS ===
  static const successColor = Color(0xFF4CAF50); // Green for success
  static const successColorLight = Color(0xFF81C784);
  static const warningColor = Color(0xFFFF9800); // Orange for warnings
  static const warningColorLight = Color(0xFFFFB74D);
  static const errorColor = Color(0xFFE53935); // Red for errors
  static const errorColorLight = Color(0xFFEF5350);
  static const infoColor = Color(0xFF2196F3); // Blue for information
  static const infoColorLight = Color(0xFF64B5F6);

  // === BORDER AND DIVIDER COLORS ===
  static const borderColor = Color(0xFF4A6B4D); // Green-tinted border
  static const borderColorLight = Color(0xFF5A7B5D); // Lighter border
  static const dividerColor = Color(0xFF3A5A3D); // Subtle divider

  // === DEPRECATED (Backward compatibility) ===
  @Deprecated('Use surfaceColor instead')
  static const polor = Color.fromARGB(255, 37, 63, 40);

  // === TEXT STYLES (Updated for accessibility) ===
  static TextStyle titleTextStyle = TextStyle(
    color: AppConsts.secondaryColor,
    fontWeight: FontWeight.bold,
  );
  static TextStyle secondTitleTextStyle = TextStyle(
    color: AppConsts.textColorPrimary,
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyTextStyle = TextStyle(
    color: AppConsts.secondaryColor,
    fontWeight: FontWeight.bold,
  );
  static TextStyle trailingTextStyle = TextStyle(
    color: AppConsts.textColorTertiary,
    fontWeight: FontWeight.bold,
  );

  // === HELPER METHODS ===
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  // Get appropriate text color for background
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calculate luminance to determine if text should be light or dark
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Color(0xFF000000) : textColorPrimary;
  }
}
