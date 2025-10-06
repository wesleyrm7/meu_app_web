import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ItemPedido.dart';

class ItemPedidoDAO {
  static Database? _db;
  static const String TABELA_ITEM_PEDIDO = "item_pedido";
  static const String TABELA_ITEM = "item";

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'carrinho.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $TABELA_ITEM_PEDIDO(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          id_produto TEXT,
          nome_produto TEXT,
          valor REAL,
          quantidade INTEGER,
          tamanho TEXT,
          estoque INTEGER,
          url_imagem_produto TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $TABELA_ITEM(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          id_firebase TEXT,
          nome TEXT,
          valor REAL,
          url_imagem TEXT
        )
      ''');
    });
  }

  Future<bool> salvar(ItemPedido item) async {
    final db = await database;
    try {
      await db.insert(TABELA_ITEM_PEDIDO, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (e) {
      print("Erro ao salvar itemPedido: $e");
      return false;
    }
  }

  Future<bool> atualizar(ItemPedido item) async {
    final db = await database;
    try {
      await db.update(
        TABELA_ITEM_PEDIDO,
        {'quantidade': item.quantidade},
        where: 'id = ?',
        whereArgs: [item.id],
      );
      return true;
    } catch (e) {
      print("Erro ao atualizar itemPedido: $e");
      return false;
    }
  }

  Future<bool> remover(ItemPedido item) async {
    final db = await database;
    try {
      await db.delete(
        TABELA_ITEM_PEDIDO,
        where: 'id = ?',
        whereArgs: [item.id],
      );
      return true;
    } catch (e) {
      print("Erro ao remover itemPedido: $e");
      return false;
    }
  }

  Future<List<ItemPedido>> getList() async {
    final db = await database;
    final res = await db.query(TABELA_ITEM_PEDIDO);
    return res.map((row) => ItemPedido.fromMap(row)).toList();
  }

  Future<void> limparCarrinho() async {
    final db = await database;
    await db.delete(TABELA_ITEM_PEDIDO);
  }
}
