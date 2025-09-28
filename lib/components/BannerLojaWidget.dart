import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannerLojaWidget extends StatefulWidget {
  const BannerLojaWidget({super.key});

  @override
  _BannerLojaWidgetState createState() => _BannerLojaWidgetState();
}

class _BannerLojaWidgetState extends State<BannerLojaWidget> {
  final DatabaseReference bannerRef = FirebaseDatabase.instance.ref('bannerLojaRoupa');
  List<String> imagens = [];
  PageController pageController = PageController();
  int currentPage = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    recuperarBanners();
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void recuperarBanners() {
    bannerRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        List<String> urls = [];
        data.forEach((key, value) {
          final caminho = value['caminhoImagem'];
          if (caminho != null) urls.add(caminho);
        });

        setState(() {
          imagens = urls;
        });

        iniciarTrocaAutomatica();
      }
    });
  }

  void iniciarTrocaAutomatica() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (imagens.isEmpty) return;

      currentPage++;
      if (currentPage >= imagens.length) currentPage = 0;

      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (imagens.isEmpty) {
      return const SizedBox(
        height: 320,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 320,
      child: Column(
        children: [
          // PageView ocupa a maior parte da altura
          SizedBox(
            height: 280, // mantem banner grande
            child: PageView.builder(
              controller: pageController,
              itemCount: imagens.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imagens[index],
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.image_not_supported),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Indicadores circulares pequenos, discretos
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              imagens.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == index ? 12 : 8,
                height: currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: currentPage == index ? Colors.black : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
