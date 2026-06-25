import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/flirt_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      // Localization is handled reactively by LanguageProvider
      // rather than standard delegate approach to support "Zero-Reboot"
      home: const SplashScreen(),
    );
  }
}
