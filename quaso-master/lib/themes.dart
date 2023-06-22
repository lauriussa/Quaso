import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quaso/constants.dart';

class QuasoTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
      brightness: Brightness.light,
      primaryColor:Color(0xFF863A6F),
      colorScheme: ColorScheme.light(
        primaryContainer: Colors.white,
        secondaryContainer: Colors.grey[100],
        primary: QuasoColors.primary,
        outline: const Color(0xFF505050),
      ),
      fontFamily: GoogleFonts.nunito().fontFamily,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF863A6F),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF303030),
      dialogTheme: const DialogTheme(surfaceTintColor: Colors.white),
      primaryColor: Colors.grey,
      fontFamily: GoogleFonts.nunito().fontFamily,
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(getSwitchColorThumb),
        trackColor: MaterialStateProperty.resolveWith(getSwitchTrackColor),
      ),
      colorScheme: const ColorScheme.dark(
        primaryContainer: Color(0xFF505050),
        secondaryContainer: Color(0xFF353535),
        primary: QuasoColors.primary,
        outline: Colors.grey,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF863A6F),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}

Color getSwitchColorThumb(Set<MaterialState> states) {
  if (states.contains(MaterialState.selected)) {
    return const Color(0xFF303030);
  }

  return Colors.grey;
}

Color getSwitchTrackColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };

  if (states.any(interactiveStates.contains)) {
    return const Color(0xFF505050);
  }

  if (states.contains(MaterialState.selected)) {
    return QuasoColors.primary;
  }

  return const Color(0xFF353535);
}
