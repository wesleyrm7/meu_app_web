import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:meu_app_web/screens/produto_home.dart';
import 'package:meu_app_web/screens/produto_screen.dart';
import '../components/BannerLojaWidget.dart';
import 'DoisBannerLojaUsuario.dart';
import 'app_bar_custom.dart';
import 'barra_busca.dart';
import 'barra_pesquisa.dart';
import 'imagens_grid.dart';
import 'menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int cartCount = 2; // exemplo de badge no carrinho

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // fundo branco da HomePage
      drawer: const MenuDrawer(),
      appBar: AppBarCustom(cartCount: cartCount),
      body: Column(
        children: [
          // Barra de busca fixa
          const BarraDeBusca(),

          // Conteúdo rolável
          Expanded(
            child: ScrollConfiguration(
              behavior: const _WebScrollBehavior(),
              child: Scrollbar(
                thumbVisibility: false,
                child: SingleChildScrollView(
                  primary: true,
                  physics: const AlwaysScrollableScrollPhysics(),
             //     padding: const EdgeInsets.all(12), TODO PADDIN DO CONTEUDO, DEIXA GRUDADO OS LADOS
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== Bloco 1: Banner da Loja =====
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // fundo branco
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const BannerLojaWidget(),
                      ),
                      const SizedBox(height: 12),

                      // ===== Bloco 2: Imagens do Firebase =====
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white, // fundo branco
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const ImagensGrid(), // grid dinâmico do Firebase
                      ),
                      const SizedBox(height: 6),

                      // ===== Bloco 3: Produtos da Loja =====
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white, // fundo branco
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ProdutoHome(), // ✅ aqui usamos a versão sem Scaffold
                      ),

                      // ===== Bloco 4: Produtos da Loja =====
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const DoisBannerLojaUsuario(),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ScrollBehavior atualizado para Web e Mobile
class _WebScrollBehavior extends MaterialScrollBehavior {
  const _WebScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}
