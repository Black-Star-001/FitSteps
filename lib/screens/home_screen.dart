// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:novo_projeto/models/exercise_model.dart'; // Importa o modelo de dados
import 'package:novo_projeto/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}); // CORRIGIDO: Removido o 'const'

  // 👇 Lendo a variável de ambiente 'APP_ENV'
  static const String appEnvironment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'production',
  );

  // Lista de exercícios de exemplo
  final List<Exercise> exercises = [
    Exercise(
      name: 'Alongamento de Pescoço',
      description:
          'Gire o pescoço lentamente para a direita e para a esquerda.',
      duration: '30 segundos',
    ),
    Exercise(
      name: 'Rotação de Ombros',
      description: 'Gire os ombros para a frente e para trás.',
      duration: '30 segundos',
    ),
    Exercise(
      name: 'Alongamento de Braços',
      description: 'Estique os braços acima da cabeça e para os lados.',
      duration: '1 minuto',
    ),
    Exercise(
      name: 'Agachamento',
      description: 'Faça 15 agachamentos para fortalecer as pernas.',
      duration: '1 minuto',
    ),
    Exercise(
      name: 'Elevação de joelhos',
      description:
          'Eleve os joelhos alternadamente, como se estivesse marchando no lugar.',
      duration: '1 minuto',
    ),
  ];

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Escolha um exercício para sua pausa:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: ListTile(
                    title: Text(exercise.name),
                    subtitle: Text(exercise.description),
                    trailing: Text(exercise.duration),
                    onTap: () {
                      // Ação ao tocar no exercício (será implementada no futuro)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${exercise.name} selecionado!'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
