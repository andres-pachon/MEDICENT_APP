import 'package:flutter/material.dart';
import 'package:medicent_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:medicent_app/features/auth/presentation/providers/medicamento_provider.dart';
import 'package:medicent_app/features/auth/presentation/providers/toma_provider.dart';
import 'package:medicent_app/features/auth/presentation/screens/landing_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MedicamentoProvider()),
        ChangeNotifierProvider(create: (_) => TomaProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Medicent',
        home: const LandingPage(),
      ),
    );
  }
}