import '../screens/ImagemUpload.dart';
import 'TamanhoInfo.dart';

class Produto {
  String id;
  int idLocal;
  String titulo;
  String descricao;
  String tamanho;
  double valorAntigo;
  double valorAtual;
  bool rascunho;
  String ofertaImperdivel;
  String pequenaDescricao;
  int estoque;
  int reservado;

  List<String> idsCategorias;
  List<ImagemUpload> urlsImagens;
  Map<String, int> estoquePorTamanho;
  Map<String, dynamic> tamanhos;
  Map<String, int> reservadoPorTamanho;
  Map<String, TamanhoInfo> tamanhosNew;

  Produto({
    this.id = '',
    this.idLocal = 0,
    this.titulo = '',
    this.descricao = '',
    this.tamanho = '',
    this.valorAntigo = 0.0,
    this.valorAtual = 0.0,
    this.rascunho = false,
    this.ofertaImperdivel = '',
    this.pequenaDescricao = '',
    this.estoque = 0,
    this.reservado = 0,
    List<String>? idsCategorias,
    List<ImagemUpload>? urlsImagens,
    Map<String, int>? estoquePorTamanho,
    Map<String, dynamic>? tamanhos,
    Map<String, int>? reservadoPorTamanho,
    Map<String, TamanhoInfo>? tamanhosNew,
  })  : idsCategorias = idsCategorias ?? [],
        urlsImagens = urlsImagens ?? [],
        estoquePorTamanho = estoquePorTamanho ?? {},
        tamanhos = tamanhos ?? {},
        reservadoPorTamanho = reservadoPorTamanho ?? {},
        tamanhosNew = tamanhosNew ?? {};

  /// Construtor a partir do snapshot Firebase
  factory Produto.fromMap(Map<dynamic, dynamic> map, String id) {
    // Conversão segura das listas de strings
    List<String> idsCategoriasList = [];
    if (map['idsCategorias'] != null) {
      idsCategoriasList = List<String>.from(map['idsCategorias']);
    }

    // Conversão das imagens
    List<ImagemUpload> urlsImagensList = [];
    if (map['urlsImagens'] != null) {
      final lista = map['urlsImagens'] as List<dynamic>;
      urlsImagensList =
          lista.map((e) => ImagemUpload.fromMap(Map<String, dynamic>.from(e))).toList();
    }

    // Conversão tamanhosNew
    Map<String, TamanhoInfo> tamanhosNewMap = {};
    if (map['tamanhosNew'] != null) {
      (map['tamanhosNew'] as Map<dynamic, dynamic>).forEach((key, value) {
        tamanhosNewMap[key.toString()] =
            TamanhoInfo.fromMap(Map<String, dynamic>.from(value));
      });
    }

    return Produto(
      id: id,
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      tamanho: map['tamanho'] ?? '',
      valorAntigo: (map['valorAntigo'] ?? 0.0).toDouble(),
      valorAtual: (map['valorAtual'] ?? 0.0).toDouble(),
      rascunho: map['rascunho'] ?? false,
      ofertaImperdivel: map['ofertaImperdivel'] ?? '',
      pequenaDescricao: map['pequenaDescricao'] ?? '',
      estoque: map['estoque'] ?? 0,
      reservado: map['reservado'] ?? 0,
      idsCategorias: idsCategoriasList,
      urlsImagens: urlsImagensList,
      estoquePorTamanho: map['estoquePorTamanho'] != null
          ? Map<String, int>.from(map['estoquePorTamanho'])
          : {},
      tamanhos: map['tamanhos'] != null ? Map<String, dynamic>.from(map['tamanhos']) : {},
      reservadoPorTamanho: map['reservadoPorTamanho'] != null
          ? Map<String, int>.from(map['reservadoPorTamanho'])
          : {},
      tamanhosNew: tamanhosNewMap,
    );
  }

  /// Converter Produto para Map (para salvar no Firebase)
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'tamanho': tamanho,
      'valorAntigo': valorAntigo,
      'valorAtual': valorAtual,
      'rascunho': rascunho,
      'ofertaImperdivel': ofertaImperdivel,
      'pequenaDescricao': pequenaDescricao,
      'estoque': estoque,
      'reservado': reservado,
      'idsCategorias': idsCategorias,
      'urlsImagens': urlsImagens.map((e) => e.toMap()).toList(),
      'estoquePorTamanho': estoquePorTamanho,
      'tamanhos': tamanhos,
      'reservadoPorTamanho': reservadoPorTamanho,
      'tamanhosNew': tamanhosNew.map((k, v) => MapEntry(k, v.toMap())),
    };
  }

  /*int getEstoqueDisponivel(String tamanho) {
    final estoqueTotal = estoquePorTamanho[tamanho] ?? 0;
    final reservadoTamanho = reservadoPorTamanho[tamanho] ?? 0;
    return estoqueTotal - reservadoTamanho;
  }*/

  int getEstoqueDisponivel(String tamanho) {
    if (tamanhos.containsKey(tamanho)) {
      final info = tamanhos[tamanho];
      final estoque = (info['estoque'] ?? 0) as int;
      final reservado = (info['reservado'] ?? 0) as int;
      return estoque - reservado;
    }
    return 0;
  }

  void atualizarDados(Map<String, dynamic> novoMapa) {
    titulo = novoMapa['titulo'] ?? titulo;
    valorAntigo = (novoMapa['valorAntigo'] ?? valorAntigo).toDouble();
    valorAtual = (novoMapa['valorAtual'] ?? valorAtual).toDouble();
    pequenaDescricao = novoMapa['pequenaDescricao'] ?? pequenaDescricao;
    tamanhos = Map<String, dynamic>.from(novoMapa['tamanhos'] ?? tamanhos);
  }
}
