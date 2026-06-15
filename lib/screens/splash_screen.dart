import 'dart:async';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    startApp();
  }

  Future<void> startApp() async {

    bool loggedIn =
        await AuthService().isLoggedIn();

    Timer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => loggedIn
                ? const DashboardScreen()
                : const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return const CircleAvatar(
                  radius: 40,
                  child: Icon(
                    Icons.grass,
                    size: 40,
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "FeedTrack Pro",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}