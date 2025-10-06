import 'package:flutter/material.dart';
import '../components/PesquisaScreen.dart';

class BarraDeBusca extends StatelessWidget {
  const BarraDeBusca({super.key});

  void abrirPesquisa(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PesquisaScreen()),
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => abrirPesquisa(context),
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: IgnorePointer(
          ignoring: true, // impede digitação aqui, só abre a tela
          child: TextField(
            decoration: InputDecoration(
              hintText: "O que você está buscando?",
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      ),
    );
  }
}
