class Categoria {
  String id;
  String nome;
  String urlImagem;
  bool todas;

  Categoria({
    required this.id,
    required this.nome,
    required this.urlImagem,
    this.todas = false,
  });

  factory Categoria.fromMap(Map<dynamic, dynamic> map, String id) {
    return Categoria(
      id: id,
      nome: map['nome'] ?? '',
      urlImagem: map['urlImagem'] ?? '',
      todas: map['todas'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'urlImagem': urlImagem,
      'todas': todas,
    };
  }
}
