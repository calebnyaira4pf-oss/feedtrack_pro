import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    const FeedTrackApp(),
  );
}

class FeedTrackApp extends StatelessWidget {

  const FeedTrackApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "FeedTrack Pro",

      theme: AppTheme.lightTheme,

      home: const SplashScreen(),
    );
  }
}