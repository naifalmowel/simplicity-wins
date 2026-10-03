import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color ink = Color(0xFF171715);
const Color muted = Color(0xFF777772);
const Color paper = Color(0xFFF7F6F2);
const Color line = Color(0xFFE8E6E0);
const Color olive = Color(0xFF676B56);

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: paper,
      primaryColor: ink,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ink,
        brightness: Brightness.light,
        surface: paper,
      ),
      textTheme: GoogleFonts.cairoTextTheme().apply(
        bodyColor: ink,
        displayColor: ink,
      ),
    );
  }
}
