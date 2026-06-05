import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PulseApp());
}

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse — Voice AI Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'sans-serif',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B2B),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w800,
            letterSpacing: -2,
          ),
          displayMedium: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
          bodyLarge: TextStyle(fontSize: 17, height: 1.6),
          bodyMedium: TextStyle(fontSize: 15, height: 1.5),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
