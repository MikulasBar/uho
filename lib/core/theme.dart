import 'package:flutter/material.dart';


class UhoColor {
  static const Color background = Color.fromARGB(255, 199, 169, 103);
  static const Color card = Color.fromARGB(255, 143, 114, 53);
  static const Color highlight = Color.fromARGB(255, 113, 150, 216);
  static const Color text1 = Color.fromARGB(255, 255, 255, 255);
  static const Color text2 = Color.fromARGB(255, 223, 223, 223);
}

class UhoTheme {
  static final main = ThemeData(
    colorScheme: ColorScheme.dark(),
    scaffoldBackgroundColor: UhoColor.background,
    cardColor: UhoColor.card,
    // primaryColor: Color.fromARGB(255, 143, 114, 53),
    focusColor: UhoColor.highlight,
  );
}

class UhoPadding {
  static const double superSmall = 2;
  static const double verySmall = 4;
  static const double small = 8;
  static const double medium = 16;
  static const double big = 32;
  static const double huge = 64;
}


class UhoCornerRadius {
  static const double small = 6;
  static const double medium = 12; 
  static const double big = 12;
  static const double bigger = 18;
  static const double huge = 24;
}

class UhoFontSize {
  static const double small = 16;
  static const double medium = 20;
  static const double big = 24;
}