import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  final storageService = StorageService();
  await storageService.init();

  final hasUser = await storageService.hasUserProfile();

  runApp(GymApp(hasUser: hasUser));
}

class GymApp extends StatelessWidget {
  final bool hasUser;

  const GymApp({super.key, required this.hasUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitForge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.orangeAccent,
          secondary: Colors.orange,
          surface: const Color(0xFF1A1A2E),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F23),
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1A2E),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0F23),
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A2E),
          selectedItemColor: Colors.orangeAccent,
          unselectedItemColor: Colors.grey,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white60, fontSize: 14),
        ),
      ),
      home: hasUser ? const HomeScreen() : const OnboardingScreen(),
    );
  }
}
