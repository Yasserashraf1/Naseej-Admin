import 'package:flutter/material.dart';

class AppColors {
  // Primary Burgundy Theme (matching mobile app)
  static const Color primary = Color(0xFF8b3c3c);
  static const Color secondary = Color(0xFFc26b6b);
  static const Color tertiary = Color(0xFF541d2c);
  static const Color accent = Color(0xFFdf9696);

  // Gold/Bronze Accents
  static const Color gold = Color(0xFFd4a574);
  static const Color bronze = Color(0xFFb8956a);

  // Earthy Tones
  static const Color earthBrown = Color(0xFF8b7355);
  static const Color desertSand = Color(0xFFd9c5a8);

  // Backgrounds
  static const Color background = Color(0xFFf1e9db);
  static const Color lightBg = Color(0xFFfefdfb);
  static const Color cardBg = Color(0xFFfefdfb);

  // Dark Theme
  static const Color darkBackground = Color(0xFF1A1614);
  static const Color darkSurface = Color(0xFF2C2520);

  // Status Colors
  static const Color success = Color(0xFF6b8b3c);
  static const Color warning = Color(0xFFc96a5c);
  static const Color error = Color(0xFFc96a5c);
  static const Color info = Color(0xFF5b9bd5);

  // Grayscale
  static const Color black = Color(0xFF000000);
  static const Color darkGray = Color(0xFF333333);
  static const Color gray = Color(0xFF8e8e8e);
  static const Color lightGray = Color(0xFFe8dcc8);
  static const Color white = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, bronze],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Chart Colors
  static const List<Color> chartColors = [
    primary,
    gold,
    success,
    secondary,
    bronze,
    earthBrown,
    info,
    accent,
  ];
}