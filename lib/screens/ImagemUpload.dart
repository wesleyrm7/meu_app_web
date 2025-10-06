class ImagemUpload {
  final int index;
  final String caminhoImagem;
  final String nomeCategoria;

  ImagemUpload({
    required this.index,
    required this.caminhoImagem,
    required this.nomeCategoria,
  });

  // Construtor para criar a partir de Map do Firebase
  factory ImagemUpload.fromMap(Map<dynamic, dynamic> map) {
    return ImagemUpload(
      index: map['index'] is int ? map['index'] : int.tryParse(map['index'].toString()) ?? 0,
      caminhoImagem: map['caminhoImagem']?.toString() ?? '',
      nomeCategoria: map['nomeCategoria']?.toString() ?? '',
    );
  }

  // Transforma para Map (caso você precise salvar no Firebase também)
  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'caminhoImagem': caminhoImagem,
      'nomeCategoria': nomeCategoria,
    };
  }
}
