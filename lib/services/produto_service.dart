import 'package:firebase_database/firebase_database.dart';
import '../model/produto.dart';

class ProdutoService {
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child("produtosLojaRoupa");

  Stream<List<Produto>> recuperarProdutosStream() {
    return _dbRef.onValue.map((event) {
      final produtosMap = event.snapshot.value as Map<dynamic, dynamic>?;

      if (produtosMap == null) return [];

      List<Produto> lista = [];

      produtosMap.forEach((key, value) {
        final produto = Produto.fromMap(value, key);
        lista.add(produto);
      });

      // Inverte a ordem (Collections.reverse em Java)
      return lista.reversed.toList();
    });
  }
}
