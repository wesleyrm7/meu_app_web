import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const int VERSION = 3;
  static const String DB_NAME = "DB_ECOMMERCE.db";
  static const String TABELA_ITEM = "TB_ITEM";
  static const String TABELA_ITEM_PEDIDO = "TB_ITEM_PEDIDO";

  static Database? _db;

  Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    String path = join(await getDatabasesPath(), DB_NAME);
    _db = await openDatabase(
      path,
      version: VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _db!;
  }

  void _onCreate(Database db, int version) async {
    String tbItem = '''
      CREATE TABLE IF NOT EXISTS $TABELA_ITEM (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_firebase TEXT NOT NULL,
        nome TEXT NOT NULL,
        valor DOUBLE NOT NULL,
        url_imagem TEXT NOT NULL
      );
    ''';

    String tbItemPedido = '''
      CREATE TABLE IF NOT EXISTS $TABELA_ITEM_PEDIDO (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_produto TEXT NOT NULL,
        valor DOUBLE NOT NULL,
        tamanho TEXT NOT NULL,
        estoque INTEGER NOT NULL,
        quantidade INTEGER NOT NULL
      );
    ''';

    await db.execute(tbItem);
    await db.execute(tbItemPedido);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          "ALTER TABLE $TABELA_ITEM_PEDIDO ADD COLUMN tamanho TEXT;");
    }
  }
}
