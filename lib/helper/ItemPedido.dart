import 'dart:typed_data'; // para representar imagem binária (equivalente a Bitmap)

class ItemPedido {
  int? id;
  String? idProduto;
  String? nomeProduto;
  double valor;
  int quantidade;
  int estoque;
  String? tamanhoProduto; // Variável nova
  String? urlImagemProduto; // URL da foto salva no Firebase Storage
  Uint8List? fotoBytes; // equivalente ao Bitmap (se precisar guardar bytes da imagem)

  ItemPedido({
    this.id,
    this.idProduto,
    this.nomeProduto,
    this.valor = 0.0,
    this.quantidade = 0,
    this.estoque = 0,
    this.tamanhoProduto,
    this.urlImagemProduto,
    this.fotoBytes,
  });

  /// Converter para Map (para salvar no SQLite ou Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_produto': idProduto,
      'nome_produto': nomeProduto,
      'valor': valor,
      'quantidade': quantidade,
      'estoque': estoque,
      'tamanho_produto': tamanhoProduto,
      'url_imagem_produto': urlImagemProduto,
      'foto_bytes': fotoBytes, // cuidado: só se for usar em SQLite
    };
  }

  /// Criar a partir de um Map (SQLite/Firebase)
  factory ItemPedido.fromMap(Map<String, dynamic> map) {
    return ItemPedido(
      id: map['id'],
      idProduto: map['id_produto'],
      nomeProduto: map['nome_produto'],
      valor: (map['valor'] as num?)?.toDouble() ?? 0.0,
      quantidade: map['quantidade'] ?? 0,
      estoque: map['estoque'] ?? 0,
      tamanhoProduto: map['tamanho_produto'],
      urlImagemProduto: map['url_imagem_produto'],
      fotoBytes: map['foto_bytes'], // pode precisar de cast para Uint8List
    );
  }
}
