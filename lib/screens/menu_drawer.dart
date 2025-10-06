import 'package:flutter/material.dart';
import '../screens/carrinho_screen.dart';
import '../model/produto.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context); // fecha o drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("Carrinho"),
            onTap: () {
              Navigator.pop(context); // fecha o drawer

              // abrir carrinho com animação
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      CarrinhoScreen(produtos: []), // pode passar produtos se houver
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    final fade = Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(parent: animation, curve: Curves.easeOut));
                    final scale = Tween<double>(begin: 0.8, end: 1).animate(
                        CurvedAnimation(parent: animation, curve: Curves.easeOutBack));
                    final slide = Tween<Offset>(
                        begin: const Offset(0, 0.2), end: Offset.zero)
                        .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

                    return FadeTransition(
                      opacity: fade,
                      child: SlideTransition(
                        position: slide,
                        child: ScaleTransition(scale: scale, child: child),
                      ),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Conta"),
            onTap: () {
              Navigator.pop(context); // fecha o drawer
           /*   Navigator.pop(context); // fecha o drawer
              // aqui você pode navegar para a tela de conta
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContaScreen(), // sua tela de conta
                ),
              );*/
            },
          ),
        ],
      ),
    );
  }
}
