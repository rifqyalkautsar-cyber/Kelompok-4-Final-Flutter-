import 'package:flutter/material.dart';

// --- STATE GLOBAL UNTUK DARK MODE ---
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// --- TEMA APLIKASI ---
const Color primaryGreen = Color(0xFF045415); // Warna Hijau Gelap UIN
const Color backgroundLight = Color(0xFFF3F7F3); // Warna latar terang (krem kehijauan)
const Color textPrimary = Color(0xFF1E1E1E);

// --- HELPER WARNA UNTUK DARK MODE ---
Color getCardColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFF1E1E1E)
    : Colors.white;
Color getTextColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? Colors.white
    : textPrimary;
Color getSurfaceColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFF2C2C2C)
    : backgroundLight;