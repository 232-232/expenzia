import 'package:flutter/material.dart';
import '../theme.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE6F2EF),
                      ),
                      child: const Icon(Icons.savings_outlined,
                          size: 110, color: AppColors.primary),
                    ),
                  ),
                ),
                const Text('Spend Smarter\nSave More',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 28,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainShell())),
                    child: const Text('Get Started'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
