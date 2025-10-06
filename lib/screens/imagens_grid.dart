import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ImagemUpload {
  final String caminhoImagem;
  final String nomeCategoria;
  final int index;

  ImagemUpload({
    required this.caminhoImagem,
    required this.nomeCategoria,
    required this.index,
  });

  factory ImagemUpload.fromMap(Map<dynamic, dynamic> map) {
    return ImagemUpload(
      caminhoImagem: map['caminhoImagem'] ?? '',
      nomeCategoria: map['nomeCategoria'] ?? '',
      index: map['index'] ?? 0,
    );
  }
}

class Categoria {
  String id;
  String nome;
  String urlImagem;

  Categoria({
    required this.id,
    required this.nome,
    required this.urlImagem,
  });
}

class ImagensGrid extends StatefulWidget {
  const ImagensGrid({super.key});

  @override
  State<ImagensGrid> createState() => _ImagensGridState();
}

class _ImagensGridState extends State<ImagensGrid> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child("bannerCategoriaLojaRoupa");
  List<Categoria> gridCategorias = List.filled(4, Categoria(id: '', nome: 'placeholder', urlImagem: ''));

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarImagens();
  }

  Future<void> carregarImagens() async {
    try {
      final snapshot = await _dbRef.get();

      if (snapshot.exists) {
        // Lista temporária de 4 posições baseada no index
        List<Categoria> temp = List.filled(4, Categoria(id: '', nome: 'placeholder', urlImagem: 'https://via.placeholder.com/150'));

        for (var ds in snapshot.children) {
          final map = ds.value as Map<dynamic, dynamic>;
          final imagem = ImagemUpload.fromMap(map);
          if (imagem.index >= 0 && imagem.index < 4) {
            temp[imagem.index] = Categoria(
              id: ds.key ?? '',
              nome: imagem.nomeCategoria,
              urlImagem: imagem.caminhoImagem,
            );
          }
        }

        setState(() {
          gridCategorias = temp;
          carregando = false;
        });
      } else {
        setState(() => carregando = false);
      }
    } catch (e) {
      debugPrint("Erro ao carregar imagens: $e");
      setState(() => carregando = false);
    }
  }

  void onClickCategoria(String id) {
    debugPrint("Clicou na categoria: $id");
    // Aqui você faz a navegação para a página da categoria
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildImagem(0)),
            const SizedBox(width: 8),
            Expanded(child: _buildImagem(1)),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildImagem(2)),
            const SizedBox(width: 8),
            Expanded(child: _buildImagem(3)),
          ],
        ),
      ],
    );
  }

  Widget _buildImagem(int index) {
    final categoria = gridCategorias[index];

    return GestureDetector(
      onTap: () => onClickCategoria(categoria.id),
      child: Container(
        height: 150,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            categoria.urlImagem,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 40),
          ),
        ),
      ),
    );
  }
}
