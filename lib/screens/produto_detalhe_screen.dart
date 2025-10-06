import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/produto.dart';
import 'carrinho_screen.dart';

class ProdutoDetalhesScreen extends StatefulWidget {
  final Produto produto;

  const ProdutoDetalhesScreen({super.key, required this.produto});

  @override
  State<ProdutoDetalhesScreen> createState() => _ProdutoDetalhesScreenState();
}

class _ProdutoDetalhesScreenState extends State<ProdutoDetalhesScreen> {
  PageController pageController = PageController();
  int currentPage = 0;
  Timer? timer;

  // ValueNotifier para tamanho selecionado
  late ValueNotifier<String?> tamanhoSelecionado;

  // Firebase
  late DatabaseReference _produtoRef;
  StreamSubscription<DatabaseEvent>? _produtoSubscription;

  @override
  void initState() {
    super.initState();
    tamanhoSelecionado = ValueNotifier<String?>(null);
    iniciarTrocaAutomatica();
    selecionarPrimeiroTamanhoDisponivel();
    iniciarListenerProduto();
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    _produtoSubscription?.cancel();
    tamanhoSelecionado.dispose();
    super.dispose();
  }

  void iniciarTrocaAutomatica() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (widget.produto.urlsImagens.isEmpty) return;

      currentPage++;
      if (currentPage >= widget.produto.urlsImagens.length) currentPage = 0;

      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  void selecionarPrimeiroTamanhoDisponivel() {
    final disponiveis = widget.produto.tamanhos.keys.where(
          (t) => widget.produto.getEstoqueDisponivel(t) > 0,
    );
    if (disponiveis.isNotEmpty) {
      tamanhoSelecionado.value = disponiveis.first;
    } else if (widget.produto.tamanhos.isNotEmpty) {
      tamanhoSelecionado.value = widget.produto.tamanhos.keys.first;
    }
  }

  void iniciarListenerProduto() {
    _produtoRef = FirebaseDatabase.instance
        .ref()
        .child("produtosLojaRoupa")
        .child(widget.produto.id);

    _produtoSubscription = _produtoRef.onValue.listen((event) {
      if (!event.snapshot.exists) return;

      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      widget.produto.atualizarDados(data);

      // Atualiza tamanho selecionado se necessário
      if (tamanhoSelecionado.value != null &&
          widget.produto.getEstoqueDisponivel(tamanhoSelecionado.value!) <= 0) {
        selecionarPrimeiroTamanhoDisponivel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final imagens = widget.produto.urlsImagens;
    final tamanhos = widget.produto.tamanhos.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto.titulo),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slider de imagens
            if (imagens.isNotEmpty)
              SizedBox(
                height: 300,
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: imagens.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: imagens[index].caminhoImagem,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image, size: 80),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        imagens.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: currentPage == index ? 12 : 8,
                          height: currentPage == index ? 12 : 8,
                          decoration: BoxDecoration(
                            color: currentPage == index ? Colors.black : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(
                height: 300,
                child: Center(child: Text("Sem imagens disponíveis")),
              ),

            const SizedBox(height: 16),
            Text(
              widget.produto.titulo,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (widget.produto.valorAntigo > 0)
                  Text(
                    "R\$ ${widget.produto.valorAntigo.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(width: 10),
                Text(
                  "R\$ ${widget.produto.valorAtual.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.produto.pequenaDescricao,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Tamanhos com ValueListenableBuilder
            if (tamanhos.isNotEmpty)
              ValueListenableBuilder<String?>(
                valueListenable: tamanhoSelecionado,
                builder: (context, tamanhoAtual, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selecione um tamanho:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: tamanhos.map((tamanho) {
                          final disponivel = widget.produto.getEstoqueDisponivel(tamanho);
                          return ChoiceChip(
                            label: Text(tamanho),
                            selected: tamanhoAtual == tamanho,
                            onSelected: disponivel > 0
                                ? (selected) => tamanhoSelecionado.value =
                            selected ? tamanho : null
                                : null,
                            backgroundColor: Colors.grey.shade300,
                            selectedColor: Colors.black,
                            labelStyle: TextStyle(
                              color: tamanhoAtual == tamanho ? Colors.white : Colors.black,
                            ),
                            disabledColor: Colors.grey.shade300.withOpacity(0.5),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tamanhoAtual != null
                            ? widget.produto.getEstoqueDisponivel(tamanhoAtual) > 0
                            ? "Estoque disponível: ${widget.produto.getEstoqueDisponivel(tamanhoAtual)}"
                            : "Estoque indisponível"
                            : "Selecione um tamanho",
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),

            // Botão comprar
            ValueListenableBuilder<String?>(
              valueListenable: tamanhoSelecionado,
              builder: (context, tamanhoAtual, _) {
                final disponivel = tamanhoAtual != null
                    ? widget.produto.getEstoqueDisponivel(tamanhoAtual)
                    : 0;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: disponivel > 0
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CarrinhoScreen(produtos: [widget.produto]),
                        ),
                      );
                    }
                        : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Selecione um tamanho disponível!")),
                      );
                    },
                    child: const Text(
                      "Comprar",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
