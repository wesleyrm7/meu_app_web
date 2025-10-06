import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/produto.dart';

class CarrinhoScreen extends StatefulWidget {
  final List<Produto> produtos;

  const CarrinhoScreen({super.key, required this.produtos});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  late Map<String, int> quantidades; // idProduto -> quantidade

  @override
  void initState() {
    super.initState();
    // inicializa quantidade = 1 para cada produto
    quantidades = {for (var p in widget.produtos) p.id.toString(): 1};
  }

  void aumentarQuantidade(Produto produto) {
    setState(() {
      quantidades[produto.id.toString()] = (quantidades[produto.id] ?? 1) + 1;
    });
  }

  void diminuirQuantidade(Produto produto) {
    setState(() {
      final atual = quantidades[produto.id] ?? 1;
      if (atual > 1) {
        quantidades[produto.id.toString()] = atual - 1;
      }
    });
  }

  void removerProduto(Produto produto) {
    setState(() {
      widget.produtos.remove(produto);
      quantidades.remove(produto.id);
    });
  }

  double calcularTotal() {
    double total = 0;
    for (var p in widget.produtos) {
      total += (quantidades[p.id] ?? 1) * p.valorAtual;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
        backgroundColor: Colors.black,
      ),
      body: widget.produtos.isEmpty
          ? const Center(
        child: Text("Seu carrinho está vazio 😢"),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.produtos.length,
              itemBuilder: (context, index) {
                final produto = widget.produtos[index];
                final quantidade = quantidades[produto.id] ?? 1;

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Imagem do produto
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: produto.urlsImagens.isNotEmpty
                                ? produto.urlsImagens.first.caminhoImagem
                                : "https://via.placeholder.com/150",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Infos principais
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produto.titulo.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Estoque: 15", // pode vir do banco
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "R\$ ${produto.valorAtual.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Botões + quantidade - e remover
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () => removerProduto(produto),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () =>
                                      diminuirQuantidade(produto),
                                ),
                                Text(
                                  "$quantidade",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  onPressed: () =>
                                      aumentarQuantidade(produto),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Total
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "R\$ ${calcularTotal().toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
