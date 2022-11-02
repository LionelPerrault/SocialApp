import 'package:flutter/material.dart';

MaterialColor kprimaryColor = createMaterialColor(Colors.black);
MaterialColor kprimarySwatch =  createMaterialColor(Colors.black);

MaterialColor kprimaryShadow = createMaterialColor(Color.fromARGB(90, 23, 130, 177));

Color ktextColor = Color(0xFF2D2D3A);
Color ksubTextColor = Color(0xFFADADB8);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  };
  return MaterialColor(color.value, swatch);
}
