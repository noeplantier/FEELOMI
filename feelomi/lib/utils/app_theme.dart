import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales
  static const Color primaryColor = Color(0xFF6B73FF);
  static const Color secondaryColor = Color(0xFF9B59B6);
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color successColor = Color(0xFF2ECC71);
  static const Color warningColor = Color(0xFFF39C12);

  // Couleurs pour les émotions
  static const Map<String, Color> emotionColors = {
    'joy': Color(0xFFFFD93D),
    'sadness': Color(0xFF6C7CE7),
    'anger': Color(0xFFFF6B6B),
    'fear': Color(0xFF845EC2),
    'disgust': Color(0xFF4E9F3D),
    'surprise': Color(0xFFFF8E53),
    'anxiety': Color(0xFFB4A7D6),
    'excitement': Color(0xFFFFB347),
    'contentment': Color(0xFF98D8C8),
    'frustration': Color(0xFFFF7F7F),
    'love': Color(0xFFFF69B4),
    'guilt': Color(0xFF8E8E93),
    'shame': Color(0xFFD2691E),
    'pride': Color(0xFFFFD700),
    'jealousy': Color(0xFF9ACD32),
    'gratitude': Color(0xFF20B2AA),
    'hope': Color(0xFF87CEEB),
    'despair': Color(0xFF483D8B),
    'calm': Color(0xFFB0E0E6),
    'stressed': Color(0xFFDC143C),
  };

  // Thème clair
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1A1A),
      onBackground: Color(0xFF1A1A1A),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
      titleTextStyle: TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 2,
      // ignore: deprecated_member_use
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      ),
      hintStyle: TextStyle(
        color: Colors.grey[500],
        fontSize: 14,
        fontFamily: 'Poppins',
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Color(0xFF666666),
        fontFamily: 'Poppins',
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFF666666),
        fontFamily: 'Poppins',
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Color(0xFF666666),
        fontFamily: 'Poppins',
      ),
    ),
  );

  // Thème sombre
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF404040)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF404040)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: const TextStyle(
        color: Color(0xFFB0B0B0),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      ),
    ),
  );

  // Couleurs spéciales pour les graphiques
  static List<Color> chartColors = [
    primaryColor,
    secondaryColor,
    accentColor,
    successColor,
    warningColor,
    const Color(0xFF3498DB),
    const Color(0xFF1ABC9C),
    const Color(0xFFE67E22),
  ];

  // Dégradés
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Ombres
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primaryColor.withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // Méthodes utilitaires
  static Color getEmotionColor(String emotionType) {
    return emotionColors[emotionType.toLowerCase()] ?? primaryColor;
  }

  static Color getIntensityColor(int intensity) {
    if (intensity <= 3) return successColor;
    if (intensity <= 6) return warningColor;
    return errorColor;
  }

  static TextStyle getEmotionTextStyle(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        );
  }
}