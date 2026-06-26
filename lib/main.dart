import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/flirt_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with safety for different platforms (Web/Android)
  try {
    await Firebase.initializeApp();
    // Perform anonymous sign-in in the background only if init succeeded
    AuthService.signInAnonymously();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    // We continue so the app still runs even if Firebase fails (common on Web during setup)
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlirtProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const FlirtMateApp(),
    ),
  );
}

class FlirtMateApp extends StatelessWidget {
  const FlirtMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    
    return MaterialApp(
      title: 'FlirtMate',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      home: const SplashScreen(),
    );
  }
}
