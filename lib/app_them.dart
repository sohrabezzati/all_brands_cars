import 'package:flutter/material.dart';

class AppTheme {
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: Color.fromARGB(255, 163, 174, 184),
    secondary: Color.fromARGB(255, 188, 201, 211),
    background: Color.fromARGB(255, 183, 197, 206),
    onBackground: Color.fromARGB(255, 169, 185, 196),
    onPrimary: Color.fromARGB(255, 177, 187, 193),
    onSecondary: Color.fromARGB(255, 196, 219, 233),
    surface: Color.fromARGB(255, 108, 160, 192),
    onSurface: Color.fromARGB(255, 118, 139, 152),
  );

  static const TextStyle titleTextStyle = TextStyle(
    color: Color.fromARGB(255, 56, 51, 51),
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle largeBodyTextStyle = TextStyle(
    color: Color.fromARGB(255, 56, 51, 51),
    fontSize: 20,
    fontWeight: FontWeight.normal,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle mediumBodyTextStyle = TextStyle(
    color: Color.fromARGB(255, 26, 25, 25),
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle smallBodyTextStyle = TextStyle(
    color: Color.fromARGB(255, 56, 51, 51),
    fontSize: 16,
    fontWeight: FontWeight.normal,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle lightHintTextStyle = TextStyle(
    color: Color.fromARGB(255, 95, 83, 83),
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    overflow: TextOverflow.ellipsis,
  );

  static const TextStyle displaySmallTextStyle = TextStyle(
    color: Color.fromARGB(255, 56, 51, 51),
    fontSize: 12,
    fontWeight: FontWeight.normal,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle displayLargTextStyle = TextStyle(
    color: Color.fromARGB(255, 56, 51, 51),
    fontSize: 16,
    fontWeight: FontWeight.normal,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle displayMediumTextStyle = TextStyle(
    color: Color.fromARGB(255, 56, 51, 51),
    fontSize: 14,
    fontWeight: FontWeight.normal,
    overflow: TextOverflow.ellipsis,
  );

  static const IconThemeData iconThemeData = IconThemeData(
    size: 28,
  );

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: lightColorScheme.background,
      expansionTileTheme: ExpansionTileThemeData(
        childrenPadding: const EdgeInsets.all(10),
        collapsedBackgroundColor: lightColorScheme.onBackground,
        backgroundColor: lightColorScheme.onSecondary,
      ),
      // listTileTheme: listTileThemeData,
      appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onBackground,
          titleTextStyle: titleTextStyle,
          iconTheme: iconThemeData),
      textTheme: const TextTheme(
          headlineLarge: titleTextStyle,
          displayLarge: displayLargTextStyle,
          displayMedium: displayMediumTextStyle,
          displaySmall: displaySmallTextStyle,
          bodyMedium: mediumBodyTextStyle,
          bodyLarge: largeBodyTextStyle,
          labelMedium: lightHintTextStyle,
          bodySmall: smallBodyTextStyle),
    );
  }
}
