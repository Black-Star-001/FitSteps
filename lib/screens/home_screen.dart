// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:novo_projeto/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 👇 Lendo a variável de ambiente 'APP_ENV'
  static const String appEnvironment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'production',
  );

  // 👇 Lendo a variável de ambiente 'API_URL' conforme o Exercício 2
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'not-set', // Valor padrão pedido no exercício
  );

  void _resetOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarColor = appEnvironment == 'dev'
        ? Colors.orange
        : Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('FitSteps ($appEnvironment)'),
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _resetOnboarding(context),
            tooltip: 'Resetar Onboarding',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bem-vindo ao aplicativo!',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            Text(
              'Executando no ambiente: $appEnvironment',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10), // Espaçamento
            // 👇 Exibindo a API_URL conforme o Exercício 2
            Text('API URL: $apiUrl', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
