import 'package:flutter/material.dart';
import '../model/produto.dart';

class CarrinhoItemWidget extends StatefulWidget {
  final Produto produto;
  final VoidCallback onRemover;

  const CarrinhoItemWidget({
    super.key,
    required this.produto,
    required this.onRemover,
  });

  @override
  State<CarrinhoItemWidget> createState() => _CarrinhoItemWidgetState();
}

class _CarrinhoItemWidgetState extends State<CarrinhoItemWidget> {
  int quantidade = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.produto.urlsImagens.isNotEmpty
                ?widget.produto.urlsImagens.first.caminhoImagem
                    : "https://via.placeholder.com/100",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Informações do produto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título + botão remover
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.produto.titulo.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: widget.onRemover,
                      ),
                    ],
                  ),

                  // Tamanho e estoque
                  Row(
                    children: [
                      const Text(
                        "Tamanho: ",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "42", // pode vir de outra propriedade sua
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Estoque: 15", // idem
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Preço + controle quantidade
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "R\$ ${widget.produto.valorAtual.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          // Botão menos
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (quantidade > 1) {
                                setState(() {
                                  quantidade--;
                                });
                              }
                            },
                          ),
                          Text(
                            quantidade.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          // Botão mais
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                quantidade++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
