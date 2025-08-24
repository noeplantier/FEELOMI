import 'package:feelomi/checking_page.dart';
import 'package:feelomi/emotions_page.dart';
import 'package:feelomi/home_page.dart';
import 'package:feelomi/login_page.dart';
import 'package:feelomi/mood_page.dart';
import 'package:feelomi/sad_page.dart';
import 'package:feelomi/services/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation Firebase
  await FirebaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feelomi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
          secondary: const Color.fromARGB(255, 90, 0, 150),
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const HomePage(),
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/emotions': (context) => const EmotionsTracker(),
        '/sad': (context) => const SadTracker(),
        '/feeling': (context) => const FeelingTracker(),
        '/checking': (context) => const CheckingPage(),
        '/mood': (context) => const MoodPage(),
      },
    );
  }
}
