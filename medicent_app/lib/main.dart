import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/home/presentation/screens/home_page.dart';
import 'features/auth/presentation/screens/landing_page.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..checkAuthStatus(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medicent',
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
      home: authProvider.isAuthenticated ? const HomePage() : const LandingPage(),
    );
  }
}