import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../screens/home/home_screen.dart';

class PrivityDrinkApp extends StatelessWidget {
  const PrivityDrinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PRIVITY DRINK',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
