import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/Categoria.dart';
import '../model/produto.dart';

class UsuarioPesquisaPage extends StatefulWidget {
  const UsuarioPesquisaPage({super.key});

  @override
  State<UsuarioPesquisaPage> createState() => _UsuarioPesquisaPageState();
}

class _UsuarioPesquisaPageState extends State<UsuarioPesquisaPage> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  List<Categoria> categorias = [];
  List<Produto> produtos = [];
  List<Produto> filtrados = [];
  Categoria? categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
    _carregarProdutos();
  }

  void _carregarCategorias() {
    _db.child("categoriasLojaRoupa").onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final lista = data.entries
            .map((e) => Categoria.fromMap(Map<String, dynamic>.from(e.value), e.key))
            .toList();

        setState(() {
          categorias = lista.reversed.toList();
        });
      }
    });
  }

  void _carregarProdutos() {
    _db.child("produtosLojaRoupa").onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final lista = data.entries
            .map((e) => Produto.fromMap(Map<String, dynamic>.from(e.value), e.key))
            .toList();

        setState(() {
          produtos = lista.reversed.toList();
          filtrados = produtos;
        });
      }
    });
  }

  void _filtrar(String pesquisa) {
    pesquisa = pesquisa.toLowerCase();
    setState(() {
      filtrados = produtos.where((produto) {
        final nomeOk = produto.titulo.toString().toLowerCase().contains(pesquisa);
        final categoriaOk = categoriaSelecionada == null ||
            categoriaSelecionada!.todas ||
            produto.idsCategorias.contains(categoriaSelecionada!.id);

        return nomeOk && categoriaOk;
      }).toList();
    });
  }

  Widget _buildCategorias() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final cat = categorias[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                categoriaSelecionada = cat;
                _filtrar(_controller.text);
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: categoriaSelecionada?.id == cat.id
                    ? Colors.blue
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(cat.nome,
                    style: TextStyle(
                      color: categoriaSelecionada?.id == cat.id
                          ? Colors.white
                          : Colors.black,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProdutos() {
    if (filtrados.isEmpty) {
      return const Center(child: Text("Nenhum produto encontrado."));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtrados.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        final produto = filtrados[index];
        return Card(
          child: InkWell(
            onTap: () {
              // TODO: abrir tela de detalhes
            },
            child: Center(child: Text(produto.titulo.toString())),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pesquisar")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Buscar produto...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: _filtrar,
              ),
            ),
            _buildCategorias(),
            const SizedBox(height: 8),
            _buildProdutos(),
          ],
        ),
      ),
    );
  }
}
