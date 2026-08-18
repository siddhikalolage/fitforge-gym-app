import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'repositories/fitforge_repository.dart';
import 'repositories/local_fitforge_repository.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

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

  final FitForgeRepository repository = LocalFitForgeRepository();
  var hasUser = false;
  String? startupError;
  try {
    await repository.init();
    hasUser = await repository.hasUserProfile();
  } on RepositoryException catch (error) {
    startupError = error.message;
  }

  runApp(
    GymApp(
      hasUser: hasUser,
      startupError: startupError,
      repository: repository,
    ),
  );
}

class GymApp extends StatelessWidget {
  final bool hasUser;
  final String? startupError;
  final FitForgeRepository? repository;

  const GymApp({
    super.key,
    required this.hasUser,
    this.startupError,
    this.repository,
  });

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
      home: startupError == null
          ? (hasUser
              ? HomeScreen(repository: repository)
              : OnboardingScreen(repository: repository))
          : StorageFailureScreen(message: startupError!),
    );
  }
}

class StorageFailureScreen extends StatelessWidget {
  final String message;

  const StorageFailureScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                color: Colors.orangeAccent,
                size: 64,
              ),
              const SizedBox(height: 24),
              const Text(
                'Secure storage unavailable',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
