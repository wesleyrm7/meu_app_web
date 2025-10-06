class ImagemUpload {
  int index;
  String caminhoImagem;
  String nomeCategoria;

  // Construtor padrão
  ImagemUpload({
    this.index = 0,
    this.caminhoImagem = '',
    this.nomeCategoria = '',
  });

  // Construtor alternativo semelhante ao Java
  ImagemUpload.comIndexECaminho(this.index, this.caminhoImagem, {this.nomeCategoria = ''});

  // Factory para criar a partir de um Map (opcional, útil para Firebase)
  factory ImagemUpload.fromMap(Map<dynamic, dynamic> map) {
    return ImagemUpload(
      index: map['index'] ?? 0,
      caminhoImagem: map['caminhoImagem'] ?? '',
      nomeCategoria: map['nomeCategoria'] ?? '',
    );
  }

  // Para converter em Map (útil para salvar no Firebase)
  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'caminhoImagem': caminhoImagem,
      'nomeCategoria': nomeCategoria,
    };
  }
}
