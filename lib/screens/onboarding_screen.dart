// lib/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:novo_projeto/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _notificationsConsent = false; // Variável para o consentimento

  // Lista de páginas do onboarding com o tema "FitSteps"
  final List<Widget> _onboardingPages = [
    // Página 1: Welcome
    _buildPage(
      'Bem-vindo ao FitSteps!',
      'Sua rotina de estudos mais saudável começa aqui. Pequenas pausas, grandes benefícios.',
    ),
    // Página 2: How it Works
    _buildPage(
      'Como Funciona?',
      'Defina suas metas de passos e receba lembretes para fazer alongamentos guiados durante seus estudos.',
    ),
    // Página 3: Consentimento (adaptado para o tema)
    _buildPage(
      'Receba Lembretes', // Título especial que identifica esta página
      'Para te ajudar a criar o hábito, o FitSteps pode enviar notificações para você fazer pausas ativas.',
    ),
    // Página 4: Go to Access
    _buildPage(
      'Tudo Pronto!',
      'Vamos definir sua primeira meta e começar a se movimentar.',
    ),
  ];

  // Método para salvar as preferências e navegar para a Home
  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    // Salva que o onboarding foi completo
    await prefs.setBool('onboarding_completed', true);
    // Salva a escolha sobre as notificações
    await prefs.setBool('notifications_consent', _notificationsConsent);

    // Navega para a home, removendo todas as telas anteriores da pilha
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ), // CORRIGIDO: Removido o 'const'
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == _onboardingPages.length - 1;
    bool isConsentPage = _currentPage == 2;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: _onboardingPages,
              ),
            ),
            // REGRA DE VISIBILIDADE: Ocultar os dots na última página
            if (!isLastPage)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: DotsIndicator(
                  dotsCount: _onboardingPages.length,
                  position: _currentPage, // CORRIGIDO: Sem .toDouble()
                  decorator: DotsDecorator(
                    color: Colors.grey, // Cor dos pontos inativos
                    activeColor: Theme.of(
                      context,
                    ).colorScheme.primary, // Cor do ponto ativo
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),

            // Espaçamento para o caso de não haver DotsIndicator na última página
            if (isLastPage) const SizedBox(height: 48),

            // Lógica de visibilidade e botões de navegação
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botão "Pular"
                  // Visível apenas ANTES da página de consentimento
                  if (_currentPage < 2)
                    TextButton(
                      onPressed: () {
                        _pageController.animateToPage(
                          2, // Pula para a página de consentimento
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Pular'),
                    ),

                  // Botão "Voltar"
                  // Oculto na primeira página
                  if (_currentPage > 0 && !isLastPage)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Voltar'),
                    ),

                  const Spacer(), // Ocupa o espaço flexível no meio
                  // Botão "Avançar" ou "Ir para o acesso"
                  if (!isLastPage)
                    ElevatedButton(
                      // Na página de consentimento, o botão fica desabilitado até o usuário escolher
                      onPressed: isConsentPage && !_notificationsConsent
                          ? null // Botão desabilitado
                          : () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                      child: const Text('Avançar'),
                    )
                  else // Na última página, mostra o botão para finalizar
                    ElevatedButton(
                      onPressed: _finishOnboarding,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Começar'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper para construir as páginas
  static Widget _buildPage(String title, String content) {
    // A página de consentimento é especial, identificada pelo seu título
    if (title == 'Receba Lembretes') {
      return _ConsentPage(title: title, content: content);
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(content, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// Widget para a página de consentimento, para gerenciar o estado do checkbox
class _ConsentPage extends StatefulWidget {
  final String title;
  final String content;

  const _ConsentPage({required this.title, required this.content});

  @override
  __ConsentPageState createState() => __ConsentPageState();
}

class __ConsentPageState extends State<_ConsentPage> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    // Acessa o estado da tela de onboarding para atualizar o consentimento
    final onboardingState = context
        .findAncestorStateOfType<_OnboardingScreenState>()!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(widget.content, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _checked,
                onChanged: (bool? value) {
                  setState(() {
                    _checked = value ?? false;
                    // Atualiza a variável na tela pai para habilitar o botão "Avançar"
                    onboardingState.setState(() {
                      onboardingState._notificationsConsent = _checked;
                    });
                  });
                },
              ),
              // Texto atualizado para o tema
              const Text('Sim, quero receber notificações.'),
            ],
          ),
        ],
      ),
    );
  }
}
