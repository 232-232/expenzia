import 'package:flutter/material.dart';
import '../theme.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryLight, AppColors.primary],
            ),
          ),
          child: const Center(
            child: Text('Expenzia',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      );
}
