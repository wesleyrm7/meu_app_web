class TamanhoInfo {
  int estoque;
  int reservado;

  TamanhoInfo({this.estoque = 0, this.reservado = 0});

  int get disponivel => estoque - reservado;

  factory TamanhoInfo.fromMap(Map<dynamic, dynamic> map) {
    return TamanhoInfo(
      estoque: map['estoque'] ?? 0,
      reservado: map['reservado'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'estoque': estoque,
      'reservado': reservado,
    };
  }
}