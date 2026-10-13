import 'package:flutter/material.dart';
import 'database/db_init.dart';
import 'screens/splash_screen.dart';
import 'state/expense_store.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDatabaseFactory();
  ExpenseStore.instance.load();
  runApp(const ExpenziaApp());
}

class ExpenziaApp extends StatelessWidget {
  const ExpenziaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Expenzia',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const SplashScreen(),
      );
}
