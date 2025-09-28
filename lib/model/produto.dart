class Produto {
  String id;
  String titulo;
  String pequenaDescricao;
  double valorAntigo;
  double valorAtual;
  List<String> urlsImagens;

  Produto({
    required this.id,
    required this.titulo,
    required this.pequenaDescricao,
    required this.valorAntigo,
    required this.valorAtual,
    required this.urlsImagens,
  });

  factory Produto.fromMap(Map<dynamic, dynamic> map, String id) {
    return Produto(
      id: id,
      titulo: map['titulo'] ?? '',
      pequenaDescricao: map['pequenaDescricao'] ?? '',
      valorAntigo: (map['valorAntigo'] ?? 0).toDouble(),
      valorAtual: (map['valorAtual'] ?? 0).toDouble(),
      urlsImagens: map['urlsImagens'] != null
          ? List<String>.from(map['urlsImagens'].map((img) => img['caminhoImagem']))
          : [],
    );
  }
}
