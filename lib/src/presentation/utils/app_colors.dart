import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppColors {
  // Couleurs principales - Version Healthy Food révisée

  static const Color primaryColor = Color(0xFF4CAF50); // Vert vif principal
  static const Color primaryGreen = Color(0xFF388E3C); // Vert plus profond
  static const Color starColor = Color(0xFFFFC107); // Jaune doré (conservé)
  static const Color errorColor = Color(0xFFD32F2F); // Rouge plus doux
  static const Color secondaryDarkColor = Color(0xFF689F38); // Vert olive

  // Nouveaux tons de vert harmonieux
  static const Color lightBackground = Color(0xFFF1F8E9); // Vert très pâle
  static const Color accentGreen = Color(0xFFC8E6C9); // Vert pastel doux
  static const Color lightGreen = Color(0xFFDCEDC8); // Vert lumière
  static const Color darkGreen = Color(0xFF1B5E20); // Vert forestier

  // Dégradés modernes
  static const Color greenGradientStart = Color(0xFF66BB6A);
  static const Color greenGradientEnd = Color(0xFF43A047);
  static List<Color> primaryGradient = [greenGradientStart, greenGradientEnd];
  static const Color lightGreenBackground = Color(0xFFF1F8E9);
  static const Color darkGreenBackground = Color(0xFF2E7D32);

  // Palette complète révisée
  static const Color primaryDarkColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFFAED581); // Vert-jaune doux
  static const Color secondaryLightColor = Color(0xFFC5E1A5); // Vert clair
  static const Color successColor = Color(0xFF4CAF50);
  static const Color likeColor = Color(0xFFE57373); // Rouge pastel
  static Color starEmptyColor = starColor.withOpacity(0.3);
  static const Color lightBorderColor = Color(0xFFE0E0E0);
  static const Color grayColor = Color(0xFF757575);
  static const Color grayLightColor = Color(0xFFEEEEEE);

  // Statuts de commande - Version raffinée
  static const Color pendingColor = Color(0xFFFFB74D);
  static const Color preparingColor = Color(0xFFFFD54F);
  static const Color deliveringColor = Color(0xFF4FC3F7);
  static const Color deliveredColor = Color(0xFF81C784);
  static const Color canceledColor = Color(0xFFEF5350);

  // Shimmer amélioré
  static const Color shimmerBaseColor = Color(0xFFE0E0E0);
  static const Color shimmerHighlightColor = Color(0xFFF5F5F5);

  // Thème clair raffiné
  static const Color lightBackgroundColor = Color(0xFFF8FBF8);
  static const Color lightTextColor = Color(0xFF263238);
  static const Color lightCardColor = Color(0xFFFFFFFF);

  // Thème sombre élégant
  static const Color darkBackgroundColor = Color(0xFF1B5E20);
  static const Color darkTextColor = Color(0xFFE8F5E9);
  static const Color darkCardColor = Color(0xFF2E7D32);
  static const Color white = Color(0xFFFFFFFF);
  static const Color primaryDarkGreen = Color(0xFF2E7D32);

  // Accents orange subtils
  static const Color lightOrangeBackground = Color(0xFFFFF3E0);
  static const Color primaryOrange = Color(0xFFFFA000); // Orange plus doux
  static const Color accentOrange = Color(0xFFFFCC80);

  // Getters (inchangés)
  Color get backgroundColor => Hive.box("myBox").get("isDarkMode") == true
      ? darkBackgroundColor
      : lightBackgroundColor;

  Color get textColor => Hive.box("myBox").get("isDarkMode") == true
      ? darkTextColor
      : lightTextColor;

  Color get cardColor => Hive.box("myBox").get("isDarkMode") == true
      ? darkCardColor
      : lightCardColor;

  Color get secondaryTextColor => Hive.box("myBox").get("isDarkMode") == true
      ? darkTextColor.withOpacity(0.8)
      : lightTextColor.withOpacity(0.6);

  Color get borderColor => Hive.box("myBox").get("isDarkMode") == true
      ? Color(0xFF424242)
      : lightBorderColor;

  Color? get hintTextColor => null;

  get iconColor => null;

  Color? get primaryTextColor => null;

  // Méthode pour obtenir une nuance de vert
  static Color greenShade(int shadeValue) {
    return primaryGreen.withOpacity(shadeValue / 100);
  }
}