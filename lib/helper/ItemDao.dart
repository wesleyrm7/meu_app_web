import '../model/produto.dart';
import 'DBHelper.dart';
import 'ItemPedido.dart';

class ItemDAO {
  final DBHelper dbHelper = DBHelper();

  ItemDAO();

  /// Salvar um produto no banco local
  Future<int> salvar(Produto produto) async {
    final db = await dbHelper.getDatabase();
    final values = <String, dynamic>{
      'id_firebase': produto.id,
      'nome': produto.titulo,
      'valor': produto.valorAtual,
    };

    // Salva a imagem principal (index == 0)
    for (var img in produto.urlsImagens) {
      if (img.index == 0) {
        values['url_imagem'] = img.caminhoImagem;
      }
    }

    try {
      return await db.insert(DBHelper.TABELA_ITEM, values);
    } catch (e) {
      print("Erro ao salvar item: $e");
      return 0;
    }
  }


  /// Remover item do banco local
  Future<bool> remover(ItemPedido itemPedido) async {
    final db = await dbHelper.getDatabase();

    try {
      final count = await db.delete(
        DBHelper.TABELA_ITEM,
        where: 'id = ?',
        whereArgs: [itemPedido.id],
      );
      print("Sucesso ao remover o itemPedido.");
      return count > 0;
    } catch (e) {
      print("Erro ao remover o itemPedido: $e");
      return false;
    }
  }
}
