// lib/main.dart

import 'package:flutter/material.dart';
import 'package:novo_projeto/screens/home_screen.dart'; // Precisamos criar este arquivo
import 'package:novo_projeto/screens/splash_screen.dart'; // E este também
import 'package:shared_preferences/shared_preferences.dart';

// Variável global para armazenar a decisão da rota
bool showOnboarding = true;

void main() async {
  // Garante que os bindings do Flutter foram inicializados antes de qualquer outra coisa
  WidgetsFlutterBinding.ensureInitialized();

  // Acessa o SharedPreferences para ver se o onboarding já foi concluído
  final prefs = await SharedPreferences.getInstance();
  // Se a chave 'onboarding_completed' for true, não mostra o onboarding
  showOnboarding = prefs.getBool('onboarding_completed') ?? true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitSteps Debug', // <-- Mude o título
      debugShowCheckedModeBanner: false, // Opcional: remove o banner "Debug"
      theme: ThemeData(
        // O professor pediu Material 3
        useMaterial3: true,

        // Paleta de cores principal
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
            0xFF14B8A6,
          ), // Teal - Cor principal para gerar o tema
          primary: const Color(0xFF14B8A6), // Teal
          secondary: const Color(0xFF4F46E5), // Indigo
          surface: const Color(0xFFFFFFFF), // Surface (Fundo) - Branco
        ),

        // Estilo para botões elevados (ElevatedButton)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xFF14B8A6,
            ), // Cor de fundo do botão (Teal)
            foregroundColor: Colors.white, // Cor do texto do botão (Branco)
          ),
        ),
      ),
      // ... o resto do código continua igual
      home: showOnboarding ? SplashScreen() : HomeScreen(),
    );
  }
}
