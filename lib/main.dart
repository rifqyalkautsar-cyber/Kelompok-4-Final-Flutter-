import 'package:flutter/material.dart';
import 'constants.dart';
import 'login_screen.dart';

void main() {
  runApp(const SmartBorrowApp());
}

class SmartBorrowApp extends StatelessWidget {
  const SmartBorrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'SmartBorrow UIN',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: primaryGreen,
            scaffoldBackgroundColor: backgroundLight,
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              centerTitle: false,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: primaryGreen,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            fontFamily: 'Poppins',
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              foregroundColor: Colors.white,
              centerTitle: false,
            ),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}