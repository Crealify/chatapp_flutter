import 'package:flutter/material.dart';

class OColors {
  OColors._(); // Prevent instantiation

  // Core Colors
  static const Color black = Color(0xFF1C1C1C);
  static const Color white = Color(0xFFFFFFFF);

  // Brand Colors
  static const Color primary = Color(0xFF4285F4); // Google Blue
  static const Color secondary = Color(0xFF34A853); // Google Green
  static const Color danger = Color(0xFFEA4335); // Google Red

  // Backgrounds
  static const Color scaffold = Color(0xFFF5F7FA);
  static const Color card = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  // Borders & Dividers
  static const Color border = Color(0xFFE5E7EB);
}

/// App background color
const Color bodyColor = OColors.scaffold;

/// AppBar / button color
const Color appBarColor = OColors.primary;
