import 'package:flutter/material.dart';

class MainThemeColors extends ThemeExtension<MainThemeColors> {
  const MainThemeColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.primaryGradient,
    required this.backgroundColor,
    required this.cardColor,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final LinearGradient primaryGradient;
  final Color backgroundColor;
  final Color cardColor;

  factory MainThemeColors.light(Color primaryColor) => MainThemeColors(
        primaryColor: primaryColor,
        secondaryColor: const Color.fromARGB(255, 62, 62, 70),
        primaryTextColor: const Color.fromARGB(255, 62, 62, 70),
        secondaryTextColor: const Color.fromARGB(255, 120, 120, 130),
        primaryGradient: const LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFFE6C30)]),
        backgroundColor: const Color(0xFFF5F6F8),
        cardColor: Colors.white,
      );

  factory MainThemeColors.dark(Color primaryColor) => MainThemeColors(
        primaryColor: primaryColor,
        secondaryColor: const Color.fromARGB(255, 166, 168, 254),
        primaryTextColor: const Color.fromARGB(255, 220, 220, 225),
        secondaryTextColor: const Color.fromARGB(255, 160, 160, 170),
        primaryGradient: const LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFFE6C30)]),
        backgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      );

  @override
  MainThemeColors copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,
    LinearGradient? primaryGradient,
    Color? backgroundColor,
    Color? cardColor,
  }) {
    return MainThemeColors(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cardColor: cardColor ?? this.cardColor,
    );
  }

  @override
  MainThemeColors lerp(
    covariant ThemeExtension<MainThemeColors>? other,
    double t,
  ) {
    if (other is! MainThemeColors) {
      return this;
    }
    return MainThemeColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
      primaryTextColor: Color.lerp(primaryTextColor, other.primaryTextColor, t)!,
      secondaryTextColor: Color.lerp(secondaryTextColor, other.secondaryTextColor, t)!,
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
    );
  }
}

class MainTheme {
  const MainTheme._();

  static const double buttonRadius = 12;

  static ThemeData get theme => light(const Color(0xFF2E7D32));

  static ThemeData light(Color primaryColor) {
    return _buildTheme(
      brightness: Brightness.light,
      colors: MainThemeColors.light(primaryColor),
    );
  }

  static ThemeData dark(Color primaryColor) {
    return _buildTheme(
      brightness: Brightness.dark,
      colors: MainThemeColors.dark(primaryColor),
    );
  }

  static ThemeData get lightTheme => light(const Color(0xFF2E7D32));
  static ThemeData get darkTheme => dark(const Color(0xFF2E7D32));

  static ThemeData _buildTheme({
    required Brightness brightness,
    required MainThemeColors colors,
  }) {
    return ThemeData(
      brightness: brightness,
      primaryColor: colors.primaryColor,
      scaffoldBackgroundColor: colors.backgroundColor,
      cardColor: colors.cardColor,
      dividerColor: brightness == Brightness.dark ? Colors.white12 : Colors.grey.shade200,
      splashColor: Colors.transparent,
      extensions: [colors],
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primaryColor,
        brightness: brightness,
        primary: colors.primaryColor,
        surface: colors.cardColor,
      ),
      useMaterial3: true,
    );
  }
}

extension MainThemeDataExtensions on ThemeData {
  MainThemeColors get colors => extension<MainThemeColors>() ?? MainThemeColors.light(primaryColor);
}

extension MainThemeBuildContextExtensions on BuildContext {
  MainThemeColors get colors => Theme.of(this).colors;
}
