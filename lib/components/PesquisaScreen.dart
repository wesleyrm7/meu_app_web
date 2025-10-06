import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/produto.dart';
import '../screens/produto_detalhe_screen.dart';

class Categoria {
  final String id;
  final String nome;
  Categoria(this.id, this.nome);
}

class PesquisaScreen extends StatefulWidget {
  final String pesquisaInicial;
  const PesquisaScreen({super.key, this.pesquisaInicial = ""});

  @override
  State<PesquisaScreen> createState() => _PesquisaScreenState();
}

class _PesquisaScreenState extends State<PesquisaScreen> {
  List<Categoria> categorias = [];
  Categoria? categoriaSelecionada;

  List<Produto> produtos = [];
  List<Produto> produtosFiltrados = [];
  Set<String> idsFavoritos = {};

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.text = widget.pesquisaInicial;
    recuperarCategorias();
    recuperarProdutos();
  }

  void recuperarCategorias() {
    final DatabaseReference categoriaRef =
    FirebaseDatabase.instance.ref().child("categoriasLojaRoupa");

    categoriaRef.onValue.listen((event) {
      final snapshot = event.snapshot;
      final List<Categoria> listaCategorias = [];

      if (snapshot.exists) {
        snapshot.children.forEach((child) {
          final id = child.key ?? '';
          final nome = child.child("nome").value as String? ?? '';
          listaCategorias.add(Categoria(id, nome));
        });
      }

      // Se existir "Todos", coloca sempre na primeira posição
      final todosIndex =
      listaCategorias.indexWhere((c) => c.nome.toLowerCase() == 'todos');
      if (todosIndex != -1) {
        final todos = listaCategorias.removeAt(todosIndex);
        listaCategorias.insert(0, todos);
      }

      setState(() {
        categorias = listaCategorias;
        categoriaSelecionada ??= categorias.first;
        filtrarProdutos();
      });
    });
  }

  void recuperarProdutos() {
    final DatabaseReference produtoRef =
    FirebaseDatabase.instance.ref().child("produtosLojaRoupa");

    produtoRef.onValue.listen((event) {
      final snapshot = event.snapshot;
      final List<Produto> listaProdutos = [];

      if (snapshot.exists) {
        snapshot.children.forEach((child) {
          final id = child.key ?? '';
          final map = Map<String, dynamic>.from(child.value as Map);
          listaProdutos.add(Produto.fromMap(map, id));
        });
      }

      setState(() {
        produtos = listaProdutos;
        filtrarProdutos();
      });
    });
  }

  void filtrarProdutos() {
    final textoPesquisa = searchController.text.toLowerCase();
    final idCategoria = categoriaSelecionada?.id ?? "todos";

    produtosFiltrados = produtos.where((produto) {
      final nomeOk = produto.titulo.toLowerCase().contains(textoPesquisa);
      final categoriaOk =
          idCategoria == "todos" || produto.idsCategorias.contains(idCategoria);
      return nomeOk && categoriaOk;
    }).toList();

    setState(() {});
  }

  void toggleFavorito(String id) {
    if (idsFavoritos.contains(id)) {
      idsFavoritos.remove(id);
    } else {
      idsFavoritos.add(id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: "O que você procura?",
            border: InputBorder.none,
            fillColor: Colors.white,
            filled: true,
          ),
          onChanged: (_) => filtrarProdutos(),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ScrollConfiguration(
          behavior: const _WebScrollBehavior(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categorias horizontais
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categorias.length,
                    itemBuilder: (context, index) {
                      final cat = categorias[index];
                      final isSelected = cat == categoriaSelecionada;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              categoriaSelecionada = cat;
                            });
                            filtrarProdutos();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            isSelected ? Colors.black : Colors.grey[300],
                            foregroundColor:
                            isSelected ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(cat.nome),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // Grid de produtos
                produtosFiltrados.isEmpty
                    ? const Center(child: Text("Nenhum produto encontrado"))
                    : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: produtosFiltrados.length,
                  itemBuilder: (context, index) {
                    final produto = produtosFiltrados[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProdutoDetalhesScreen(
                              produto: produto,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Hero(
                                tag: 'produto_${produto.id}',
                                child: CachedNetworkImage(
                                  imageUrl: produto.urlsImagens.isNotEmpty
                                      ? produto.urlsImagens[0].caminhoImagem
                                      : "",
                                  placeholder: (context, url) =>
                                  const Center(
                                      child:
                                      CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.broken_image,
                                      size: 50),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    produto.titulo,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "R\$ ${produto.valorAtual.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          idsFavoritos.contains(produto.id)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            toggleFavorito(produto.id),
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
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
