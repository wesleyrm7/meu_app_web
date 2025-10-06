import 'package:flutter/material.dart';
import 'package:meu_app_web/screens/produto_detalhe_screen.dart';
import '../components/produto_card.dart';
import '../services/produto_service.dart';
import '../model/produto.dart';

class ProdutoHome extends StatelessWidget {
  final ProdutoService produtoService = ProdutoService();

  ProdutoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // altura fixa do card de produtos
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

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: produtos.length,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final produto = produtos[index];

              return SizedBox(
                width: 160, // largura da imagem -> controla o tamanho
                child: ProdutoCard(
                  produto: produto,
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
            },
          );
        },
      ),
    );
  }
}
