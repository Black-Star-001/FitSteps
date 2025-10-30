// lib/screens/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:novo_projeto/screens/onboarding_screen.dart'; // Tela que vamos criar

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Usa um Future.microtask para garantir que a navegação ocorra após o build da tela
    Future.microtask(() {
      // Aguarda 3 segundos (opcional, como diz o documento) e navega para o onboarding
      Timer(Duration(seconds: 3), () {
        // 'mounted' verifica se o widget ainda está na árvore de widgets
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OnboardingScreen()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Você pode adicionar seu logo aqui
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Carregando...'),
          ],
        ),
      ),
    );
  }
}
