# Accessible Color Palette Guide

## Overview
This document outlines the enhanced, accessible color palette implemented in the mosque dashboard application. The new color scheme preserves the original brand colors while significantly improving accessibility and visual appeal.

## Brand Colors (Preserved)
- **Primary Green**: `#2D4D32` (RGB: 45, 77, 50) - Islamic traditional green
- **Secondary Gold**: `#FFD700` (RGB: 255, 215, 0) - Traditional Islamic gold

## Color Palette

### Primary Colors
```dart
primaryColor = Color.fromRGBO(45, 77, 50, 1)      // Original brand green
primaryColorLight = Color(0xFF5A9960)             // Lighter green for hover states  
primaryColorDark = Color(0xFF1B3A1E)             // Darker green for depth
primaryColorAccent = Color(0xFF3D6B42)           // Medium green for active states
```

### Secondary Colors
```dart
secondaryColor = Color(0xFFFFD700)                // Original brand gold
secondaryColorLight = Color(0xFFFFF176)          // Light gold for subtle highlights
secondaryColorDark = Color(0xFFDAA520)           // Darker gold for better contrast
secondaryColorAccent = Color(0xFFFDD835)         // Vibrant gold for important elements
```

### Neutral Colors (WCAG Compliant)
```dart
surfaceColor = Color(0xFF2C4A30)                 // Green-tinted surface
surfaceColorLight = Color(0xFF3A5F3E)           // Lighter surface for cards
surfaceColorDark = Color(0xFF1E3522)            // Darker surface for depth
backgroundColor = Color(0xFF1A2E1D)              // Very dark green background
backgroundColorAlt = Color(0xFF243528)          // Alternative background
```

### Text Colors (High Contrast)
```dart
textColorPrimary = Color(0xFFFFFFFF)            // Pure white for highest contrast
textColorSecondary = Color(0xFFE8F5E8)         // Slightly green-tinted white
textColorTertiary = Color(0xFFB8D4BA)          // Light green for less important text
textColorMuted = Color(0xFF8FA091)             // Muted green for disabled text
```

### Semantic Colors
```dart
successColor = Color(0xFF4CAF50)                // Material Design Green
warningColor = Color(0xFFFF9800)                // Material Design Orange
errorColor = Color(0xFFE53935)                  // Material Design Red
infoColor = Color(0xFF2196F3)                   // Material Design Blue
```

### Border & Divider Colors
```dart
borderColor = Color(0xFF4A6B4D)                 // Green-tinted border
borderColorLight = Color(0xFF5A7B5D)           // Lighter border
dividerColor = Color(0xFF3A5A3D)               // Subtle divider
```

## Accessibility Compliance

### WCAG 2.1 AA Standards Met
- **Normal Text**: All text colors provide at least 4.5:1 contrast ratio against their backgrounds
- **Large Text**: All large text (18pt+) provides at least 3:1 contrast ratio
- **UI Elements**: Interactive elements meet minimum 3:1 contrast requirements

### Color Contrast Examples
- White text on dark green background: >7:1 ratio (AAA compliant)
- Gold text on dark green background: >4.5:1 ratio (AA compliant)
- Light green text on dark surface: >4.5:1 ratio (AA compliant)

## Design Improvements

### Visual Enhancements
1. **Depth and Hierarchy**: Added proper shadow and elevation systems
2. **Modern Borders**: Rounded corners (12-16px) for modern feel
3. **Consistent Spacing**: Standardized padding and margins
4. **Enhanced Cards**: Proper shadows and subtle borders
5. **Better Typography**: Improved font weights and sizes

### Accessibility Features
1. **High Contrast**: All text is easily readable
2. **Color Independence**: Information is not conveyed by color alone
3. **Semantic Colors**: Consistent use of green for success, red for errors, etc.
4. **Focus Indicators**: Enhanced button and input focus states

## Usage Guidelines

### Do's
- Use `textColorPrimary` for important headings and main content
- Use `secondaryColor` for accent elements and calls-to-action
- Use semantic colors for status indicators
- Apply consistent border radius (12-16px)
- Use proper elevation and shadows

### Don'ts
- Don't use pure black or pure white unless necessary
- Don't rely on color alone to convey information
- Don't use low contrast combinations
- Avoid using deprecated `polor` color (use `surfaceColor` instead)

## Implementation

The color system is centralized in `lib/appConsts.dart` and automatically applied through the app's ThemeData in `lib/main.dart`. All UI components should reference these constants rather than hardcoded colors.

## Testing

Colors have been tested with:
- WebAIM Contrast Checker
- WCAG 2.1 guidelines
- Color blindness simulators
- Various screen brightness levels

This ensures the app is accessible to users with visual impairments and provides an excellent user experience for all users.
