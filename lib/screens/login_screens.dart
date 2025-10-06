import 'package:flutter/material.dart';
import 'package:meu_app_web/services/auth_service.dart';
import 'package:meu_app_web/screens/register_screen.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _loading = false;

  void _entrar() async {
    setState(() => _loading = true);

    final auth = AuthService();
    String? result = await auth.entrarUsuario(
      email: _emailController.text.trim(),
      senha: _senhaController.text.trim(),
    );

    setState(() => _loading = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
    // Se result == null, o usuário está autenticado
    // e o StreamBuilder do RoteadorTelas vai levar pra HomeScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// GIF no topo
              SizedBox(
                height: 230,
                width: double.infinity,
                child: Image.asset(
                  "assets/lelodownload.gif",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              /// Caixa branca com inputs e botões
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "E-mail",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      obscureText: true,
                      controller: _senhaController,
                      decoration: const InputDecoration(
                        hintText: "Senha",
                      ),
                    ),
                    const SizedBox(height: 16),
                    _loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _entrar,
                      child: const Text("Entrar"),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // aqui futuramente você pode integrar login com Google
                      },
                      child: const Text("Entrar com Google"),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Ainda não tem uma conta? Crie uma conta!",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
