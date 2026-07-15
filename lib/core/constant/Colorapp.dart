import 'package:flutter/material.dart';

class AppColor {
  // --- User's New Theme Colors ---
  static const Color primarycolor = Color.fromARGB(255, 242, 243, 245);
  static const Color white = Colors.white;
  static const Color backgroundcolor = Color(0xFF4F46E5); // Indigo
  static const Color grey = Color.fromRGBO(141, 140, 140, 1);
  static const Color red = Colors.red;
  static const Color black = Colors.black;

  // --- Legacy Aliases (Updated to match new theme) ---
  // Mapped to the new Indigo color (backgroundcolor)
  static const Color primaryPurple = backgroundcolor;
  static const Color accentPurple = Color(0xFF6366F1); // Lighter indigo
  static const Color deepPurple = Color(0xFF3730A3); // Darker indigo
  static const Color lightBlue = Color(0xFFE0E7FF); // Indigo light tint

  static const List<Color> purpleGradient = [
    accentPurple,
    backgroundcolor,
  ];

  // Backgrounds mapped to new theme
  static const Color backgroundLight = primarycolor; // Using the light color requested
  static const Color backgroundDark = Color(0xFF0F0F1A); // Kept for dark mode
  static const Color surfaceDark = Color(0xFF1B1B2F); // Kept for dark mode
  
  // Sidebar Colors
  static const Color sidebarLight = white;
  static const Color sidebarDark = surfaceDark;

  // Text Colors
  static const Color textLight = Color(0xFF2D2D2D);
  static const Color textDark = Color(0xFFE0E0E0);
  static const Color textSecondary = grey;
}
