import 'package:firebase_database/firebase_database.dart';
import '../model/Categoria.dart';

class CategoriaService {
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child("categoriasLojaRoupa");

  Future<List<Categoria>> recuperarCategorias() async {
    final snapshot = await _dbRef.get();
    if (!snapshot.exists) return [];

    List<Categoria> lista = [];
    final map = snapshot.value as Map<dynamic, dynamic>;
    map.forEach((key, value) {
      lista.add(Categoria.fromMap(value, key));
    });

    // Coloca "Todos" no início se existir
    lista.sort((a, b) => b.todas ? 1 : -1);
    return lista;
  }
}
