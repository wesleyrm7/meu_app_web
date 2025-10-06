import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js' as js;
import '../screens/home_page.dart';
import '../screens/login_screens.dart';

class RootPage extends StatelessWidget {
  final bool usuarioLogado;

  const RootPage({super.key, required this.usuarioLogado});

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    const limiteCelular = 500;

    if (largura > limiteCelular) {
      // Tela grande: mostra mensagem com fade-in
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              builder: (context, opacity, child) => Opacity(
                opacity: opacity,
                child: child,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.smartphone,
                      size: 80, color: Colors.white70),
                  const SizedBox(height: 20),
                  const Text(
                    "Este app funciona apenas em dispositivos móveis.",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (kIsWeb) {
                        js.context.callMethod('location.reload');
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Recarregar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Tela pequena (celular): abre login ou home normalmente
    return usuarioLogado ? HomePage() : LoginScreens();
  }
}
