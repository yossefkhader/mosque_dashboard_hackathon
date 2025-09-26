import 'package:flutter/material.dart';
import 'package:mosque_dashboard/pages/navigationPage.dart';
import 'package:mosque_dashboard/appConsts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mosque_dashboard/pages/signinPage.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Helper method to create MaterialColor from Color
  MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('ar'), // Arabic locale
      supportedLocales: [
        Locale('ar', ''), // Arabic
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      title: 'يسارعون في الخيرات',
      theme: ThemeData(
        // Use brand colors for primary theme
        primarySwatch: _createMaterialColor(AppConsts.primaryColor),
        primaryColor: AppConsts.primaryColor,
        scaffoldBackgroundColor: AppConsts.backgroundColor,
        colorScheme: ColorScheme.dark(
          primary: AppConsts.primaryColor,
          primaryContainer: AppConsts.primaryColorAccent,
          secondary: AppConsts.secondaryColor,
          secondaryContainer: AppConsts.secondaryColorAccent,
          surface: AppConsts.surfaceColor,
          background: AppConsts.backgroundColor,
          error: AppConsts.errorColor,
          onPrimary: AppConsts.textColorPrimary,
          onSecondary: AppConsts.primaryColor,
          onSurface: AppConsts.textColorPrimary,
          onBackground: AppConsts.textColorSecondary,
          onError: AppConsts.textColorPrimary,
          brightness: Brightness.dark,
        ),

        // Enhanced text theme with proper contrast
        textTheme: TextTheme(
          displayLarge: TextStyle(
              color: AppConsts.textColorPrimary, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(
              color: AppConsts.textColorPrimary, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(
              color: AppConsts.textColorPrimary, fontWeight: FontWeight.w600),
          headlineLarge: TextStyle(
              color: AppConsts.secondaryColor, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
              color: AppConsts.secondaryColor, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(
              color: AppConsts.secondaryColor, fontWeight: FontWeight.w500),
          titleLarge: TextStyle(
              color: AppConsts.textColorPrimary, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(
              color: AppConsts.textColorSecondary, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(
              color: AppConsts.textColorSecondary, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: AppConsts.textColorSecondary),
          bodyMedium: TextStyle(color: AppConsts.textColorSecondary),
          bodySmall: TextStyle(color: AppConsts.textColorTertiary),
          labelLarge: TextStyle(
              color: AppConsts.textColorPrimary, fontWeight: FontWeight.w500),
          labelMedium: TextStyle(
              color: AppConsts.textColorSecondary, fontWeight: FontWeight.w500),
          labelSmall: TextStyle(
              color: AppConsts.textColorTertiary, fontWeight: FontWeight.w400),
        ),

        // Enhanced input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppConsts.surfaceColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppConsts.borderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppConsts.borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppConsts.secondaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppConsts.errorColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppConsts.errorColor, width: 2),
          ),
          labelStyle:
              TextStyle(color: AppConsts.textColorTertiary, fontSize: 16),
          hintStyle: TextStyle(color: AppConsts.textColorMuted, fontSize: 16),
          helperStyle:
              TextStyle(color: AppConsts.textColorTertiary, fontSize: 12),
          errorStyle: TextStyle(color: AppConsts.errorColor, fontSize: 12),
          prefixIconColor: AppConsts.textColorTertiary,
          suffixIconColor: AppConsts.textColorTertiary,
        ),

        // Enhanced button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConsts.secondaryColor,
            foregroundColor: AppConsts.primaryColor,
            disabledBackgroundColor: AppConsts.textColorMuted,
            disabledForegroundColor: AppConsts.textColorTertiary,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.2),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppConsts.secondaryColor,
            disabledForegroundColor: AppConsts.textColorMuted,
            side: BorderSide(color: AppConsts.secondaryColor, width: 1.5),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppConsts.secondaryColor,
            disabledForegroundColor: AppConsts.textColorMuted,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),

        // Card theme
        cardTheme: CardTheme(
          color: AppConsts.surfaceColor,
          shadowColor: Colors.black.withOpacity(0.3),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppConsts.borderColor, width: 0.5),
          ),
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        ),

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppConsts.surfaceColorDark,
          foregroundColor: AppConsts.textColorPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppConsts.textColorPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: AppConsts.secondaryColor),
          actionsIconTheme: IconThemeData(color: AppConsts.secondaryColor),
        ),

        // Icon theme
        iconTheme: IconThemeData(
          color: AppConsts.secondaryColor,
          size: 24,
        ),

        // Divider theme
        dividerTheme: DividerThemeData(
          color: AppConsts.dividerColor,
          thickness: 1,
          space: 1,
        ),

        // Drawer theme
        drawerTheme: DrawerThemeData(
          backgroundColor: AppConsts.surfaceColor,
          scrimColor: Colors.black.withOpacity(0.6),
        ),

        // Dialog theme
        dialogTheme: DialogTheme(
          backgroundColor: AppConsts.surfaceColor,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: AppConsts.textColorPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          contentTextStyle: TextStyle(
            color: AppConsts.textColorSecondary,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // Bottom navigation bar theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppConsts.surfaceColor,
          selectedItemColor: AppConsts.secondaryColor,
          unselectedItemColor: AppConsts.textColorTertiary,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
          type: BottomNavigationBarType.fixed,
        ),

        // Switch theme
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppConsts.secondaryColor;
            }
            return AppConsts.textColorMuted;
          }),
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppConsts.secondaryColorLight.withOpacity(0.5);
            }
            return AppConsts.surfaceColorLight;
          }),
        ),

        // Checkbox theme
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppConsts.secondaryColor;
            }
            return Colors.transparent;
          }),
          checkColor: MaterialStateProperty.all(AppConsts.primaryColor),
          side: BorderSide(color: AppConsts.borderColor, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),

        // Radio theme
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return AppConsts.secondaryColor;
            }
            return AppConsts.borderColor;
          }),
        ),

        // Slider theme
        sliderTheme: SliderThemeData(
          activeTrackColor: AppConsts.secondaryColor,
          inactiveTrackColor: AppConsts.surfaceColorLight,
          thumbColor: AppConsts.secondaryColor,
          overlayColor: AppConsts.secondaryColorLight.withOpacity(0.2),
          valueIndicatorColor: AppConsts.secondaryColor,
          valueIndicatorTextStyle: TextStyle(color: AppConsts.primaryColor),
        ),
      ),
      home: SignInPage(),
      routes: {
        '/navigation': (context) => NavigationPage(),
      },
    );
  }
}
