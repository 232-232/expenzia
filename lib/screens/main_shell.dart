import 'package:flutter/material.dart';
import '../theme.dart';
import 'expense_form_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  Widget _placeholder(String t) => Center(
      child: Text('$t (not part of this test)',
          style: const TextStyle(color: AppColors.textGrey)));

  Widget _navIcon(IconData icon, int i) => IconButton(
        icon: Icon(icon,
            color: _index == i ? Colors.white : Colors.white60, size: 26),
        onPressed: () => setState(() => _index = i),
      );

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const HistoryScreen(),
      _placeholder('Credit'),
      _placeholder('Profile'),
    ];
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: IndexedStack(index: _index, children: pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ExpenseFormScreen())),
        child: const Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.primary,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navIcon(Icons.home_outlined, 0),
              _navIcon(Icons.history, 1),
              const SizedBox(width: 48),
              _navIcon(Icons.account_balance_wallet_outlined, 2),
              _navIcon(Icons.person_outline, 3),
            ],
          ),
        ),
      ),
    );
  }
}
