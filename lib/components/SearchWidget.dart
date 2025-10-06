import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final Function(String) onSearchTap;

  const SearchWidget({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          onSubmitted: (value) => onSearchTap(value),
          decoration: InputDecoration(
            hintText: 'O que você está buscando?',
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
