import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:meu_app_web/screens/produto_detalhe_screen.dart';
import '../components/CabecalhoWidget.dart';
import '../components/PesquisaScreen.dart';
import '../components/SearchWidget.dart';
import '../components/BannerLojaWidget.dart';
import '../components/produto_card.dart';
import '../services/produto_service.dart';
import '../model/produto.dart';

class ProdutoScreen extends StatelessWidget {
  final ProdutoService produtoService = ProdutoService();

  ProdutoScreen({super.key});

  void abrirPesquisaScreen(BuildContext context, {String pesquisaInicial = ""}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PesquisaScreen(pesquisaInicial: pesquisaInicial),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CabecalhoWidget(),
      body: Stack(
        children: [

          // SearchWidget fixo no topo, abaixo do AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SearchWidget(
              onSearchTap: (pesquisaInicial) {
                abrirPesquisaScreen(context, pesquisaInicial: pesquisaInicial);
              },
            ),
          ),
        ],
      ),
    );
  }
}
