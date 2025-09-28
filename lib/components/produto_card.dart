import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../model/produto.dart';

class ProdutoCard extends StatelessWidget {
  final Produto produto;
  final VoidCallback onComprar;
  final VoidCallback onFavorito;

  const ProdutoCard({
    super.key,
    required this.produto,
    required this.onComprar,
    required this.onFavorito,
  });

  @override
  Widget build(BuildContext context) {
    final desconto = (produto.valorAntigo > 0)
        ? (((produto.valorAntigo - produto.valorAtual) / produto.valorAntigo) * 100).round()
        : 0;

    final parcela = (produto.valorAtual / 12);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem + desconto
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: produto.urlsImagens.isNotEmpty ? produto.urlsImagens[0] : "",
                  height: 140, // um pouco menor para celular
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                ),
              ),
              if (desconto > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "-$desconto% OFF",
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),

          // Conteúdo
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto.titulo,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  produto.pequenaDescricao,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "R\$ ${produto.valorAtual.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(width: 6),
                    if (produto.valorAntigo > 0)
                      Text(
                        "R\$ ${produto.valorAntigo.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 11, color: Colors.grey, decoration: TextDecoration.lineThrough),
                      ),
                  ],
                ),
                if (produto.valorAtual > 0)
                  Text(
                    "12x de R\$ ${parcela.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                const SizedBox(height: 6),

                // Botões
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye, color: Colors.red, size: 18),
                      onPressed: onFavorito,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onComprar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("COMPRAR", style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
