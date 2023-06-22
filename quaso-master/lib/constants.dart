import 'package:flutter/material.dart';

List<String> months = [
  "",
  "Janeiro",
  "Fevereiro",
  "Março",
  "Abril",
  "Maio",
  "Junho",
  "Julho",
  "Agosto",
  "Setembro",
  "Outubro",
  "Novembro",
  "Dezembro",
];

enum Themes { device, light, dark }

enum DayType { clear, check, fail, skip }

class QuasoColors {
  static const Color primary = Color(0xFF863A6F);
  static const Color red = Color(0xFFF44336);
  static const Color skip = Color(0xFFFBC02D);
  static const Color orange = Color.fromARGB(255, 184, 76, 1);
}
