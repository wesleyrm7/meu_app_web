import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import '../components/CabecalhoWidget.dart';
import '../components/SearchWidget.dart';
import '../components/BannerLojaWidget.dart';
import '../components/produto_card.dart';
import '../services/produto_service.dart';
import '../model/produto.dart';

class ProdutoScreen extends StatelessWidget {
  final ProdutoService produtoService = ProdutoService();

  ProdutoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CabecalhoWidget(), // cabeçalho fixo
      body: Stack(
        children: [
          // Conteúdo rolável
          Padding(
            padding: const EdgeInsets.only(top: 70), // altura do SearchWidget
            child: StreamBuilder<List<Produto>>(
              stream: produtoService.recuperarProdutosStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhum produto disponível"));
                }
                final produtos = snapshot.data!;

                return ScrollConfiguration(
                  behavior: const _WebScrollBehavior(),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // Banner
                      BannerLojaWidget(),

                      // Grid de produtos
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: produtos.map((produto) {
                            return SizedBox(
                              width: (MediaQuery.of(context).size.width / 2) - 18,
                              child: ProdutoCard(
                                produto: produto,
                                onComprar: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Comprar: ${produto.titulo}"),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                },
                                onFavorito: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Visualizar: ${produto.titulo}"),
                                      backgroundColor: Colors.black,
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // SearchWidget fixo no topo, abaixo do AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const SearchWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom ScrollBehavior para Web e Mobile
class _WebScrollBehavior extends ScrollBehavior {
  const _WebScrollBehavior();
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) =>
      child;

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
