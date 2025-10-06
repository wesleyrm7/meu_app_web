import 'package:firebase_database/firebase_database.dart';
import '../model/Categoria.dart';
import '../model/produto.dart';

class ProdutoService {
  final DatabaseReference _produtoRef =
  FirebaseDatabase.instance.ref().child("produtosLojaRoupa");
  final DatabaseReference _categoriaRef =
  FirebaseDatabase.instance.ref().child("categoriasLojaRoupa");

  // Recupera todos os produtos como Stream
  Stream<List<Produto>> recuperarProdutosStream() {
    return _produtoRef.onValue.map((event) {
      final produtosMap = event.snapshot.value as Map<dynamic, dynamic>?;

      if (produtosMap == null) return [];

      List<Produto> lista = [];
      produtosMap.forEach((key, value) {
        final produto = Produto.fromMap(value, key);
        lista.add(produto);
      });

      // Inverte a ordem (como Collections.reverse em Java)
      return lista.reversed.toList();
    });
  }

  // Recupera um produto específico por ID
  Future<Produto?> recuperarProdutoPorId(String produtoId) async {
    final snapshot = await _produtoRef.child(produtoId).get();
    if (!snapshot.exists) return null;

    return Produto.fromMap(snapshot.value as Map<dynamic, dynamic>, snapshot.key!);
  }

  // Recupera produtos similares pela primeira categoria (ignora "Todos")
  Future<List<Produto>> recuperarProdutosSimilares(String produtoId) async {
    // Passo 1: pegar ID da categoria "Todos"
    final categoriasSnapshot = await _categoriaRef.get();
    String? idTodos;
    if (categoriasSnapshot.exists) {
      final categoriasMap = categoriasSnapshot.value as Map<dynamic, dynamic>;
      categoriasMap.forEach((key, value) {
        final todas = value['todas'] as bool?;
        if (todas == true) idTodos = key;
      });
    }

    // Passo 2: pegar produto clicado
    final snapshotProduto = await _produtoRef.child(produtoId).get();
    if (!snapshotProduto.exists) return [];
    final produtoClicado =
    Produto.fromMap(snapshotProduto.value as Map<dynamic, dynamic>, snapshotProduto.key!);

    // Categorias do produto clicado sem "Todos"
    final categoriasProdutoClicado = produtoClicado.idsCategorias
        .where((id) => id != idTodos)
        .toList();

    if (categoriasProdutoClicado.isEmpty) return [];

    final categoriaReal = categoriasProdutoClicado.first;

    // Passo 3: buscar todos os produtos
    final todosProdutosSnapshot = await _produtoRef.get();
    if (!todosProdutosSnapshot.exists) return [];

    final todosProdutosMap = todosProdutosSnapshot.value as Map<dynamic, dynamic>;
    List<Produto> similares = [];

    todosProdutosMap.forEach((key, value) {
      final produto = Produto.fromMap(value, key);
      if (produto.id == produtoId) return; // ignora produto clicado
      if (produto.idsCategorias.contains(categoriaReal)) {
        similares.add(produto);
      }
    });

    return similares;
  }

  // Filtra produtos por pesquisa e categoria
  Future<List<Produto>> filtrarProdutos(
      {String pesquisa = '', Categoria? categoria}) async {
    final snapshot = await _produtoRef.get();
    if (!snapshot.exists) return [];

    final produtosMap = snapshot.value as Map<dynamic, dynamic>;
    List<Produto> lista = [];
    produtosMap.forEach((key, value) {
      final produto = Produto.fromMap(value, key);
      lista.add(produto);
    });

    // Filtra
    final filtrados = lista.where((produto) {
      final bool categoriaOk = categoria == null ||
          categoria.todas ||
          produto.idsCategorias.contains(categoria.id);
      final bool pesquisaOk =
      produto.titulo.toLowerCase().contains(pesquisa.toLowerCase());
      return categoriaOk && pesquisaOk;
    }).toList();

    return filtrados;
  }

  Stream<Produto?> recuperarProdutoPorIdStream(String produtoId) { // Uso na tela de Detalhes. Atualiza o estoque " reservado"em tempo real
    return _produtoRef.child(produtoId).onValue.map((event) {
      if (!event.snapshot.exists) return null;

      final produtoMap = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
      return Produto.fromMap(produtoMap, event.snapshot.key!);
    });
  }
}
