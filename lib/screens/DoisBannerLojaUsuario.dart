import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'imagens_grid.dart'; // <-- ajuste o caminho para onde seu ImagemUpload.dart está

class DoisBannerLojaUsuario extends StatefulWidget {
  const DoisBannerLojaUsuario({super.key});

  @override
  State<DoisBannerLojaUsuario> createState() => _DoisBannerLojaUsuarioState();
}

class _DoisBannerLojaUsuarioState extends State<DoisBannerLojaUsuario> {
  final DatabaseReference _dbRef =
  FirebaseDatabase.instance.ref().child('bannerDoisCategoriaLojaRoupa');

  // placeholders iniciais (pode usar asset ou url)
  List<ImagemUpload> _banners = List.generate(
    2,
        (i) => ImagemUpload(
      caminhoImagem: 'https://via.placeholder.com/600x150?text=Banner+$i',
      nomeCategoria: 'placeholder',
      index: i,
    ),
  );

  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _recuperaBannerLoja();
  }

  Future<void> _recuperaBannerLoja() async {
    try {
      final snapshot = await _dbRef.get();

      if (snapshot.exists) {
        List<ImagemUpload> imagensTemp = [];

        for (final ds in snapshot.children) {
          final value = ds.value;
          if (value is Map) {
            final imagem = ImagemUpload.fromMap(value);
            // garante que tenha caminho válido
            if (imagem.caminhoImagem.isNotEmpty) {
              imagensTemp.add(imagem);
            }
          }
        }

        // ordena por index
        imagensTemp.sort((a, b) => a.index.compareTo(b.index));

        // monta lista final garantindo 2 posições (placeholders se faltar)
        List<ImagemUpload> finalList = [];
        for (int i = 0; i < 2; i++) {
          final found = imagensTemp.firstWhere(
                (e) => e.index == i,
            orElse: () => ImagemUpload(
              caminhoImagem: 'https://via.placeholder.com/600x150?text=Banner+$i',
              nomeCategoria: 'placeholder',
              index: i,
            ),
          );
          finalList.add(found);
        }

        setState(() {
          _banners = finalList;
          _carregando = false;
        });
      } else {
        setState(() => _carregando = false);
      }
    } catch (e) {
      debugPrint('Erro ao recuperar banners: $e');
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        _buildBanner(_banners[0]),
        _buildBanner(_banners[1]),
      ],
    );
  }

  Widget _buildBanner(ImagemUpload banner) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Image.network(
          banner.caminhoImagem,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image, size: 40),
        ),
      ),
    );
  }
}
