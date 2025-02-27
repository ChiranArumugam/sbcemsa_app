import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart'; // Import the SplashScreen
import 'view_models/library_view_model.dart';
import 'UI/colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LibraryViewModel()..initialize(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorKey: OverlayManager.navigatorKey,
      title: 'PDF Browser',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        hintColor: AppColors.accent,
        scaffoldBackgroundColor: AppColors.background,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.primary),
          bodyMedium: TextStyle(color: AppColors.primary),
          titleLarge: TextStyle(
            color: AppColors.secondary,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.background, 
            backgroundColor: AppColors.accent, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.background,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          error: AppColors.accent,
          onError: Colors.white,
        ).copyWith(surface: AppColors.background),
      ),
      home: SplashScreen(), // Set SplashScreen as the initial screen
    );
  }
}
