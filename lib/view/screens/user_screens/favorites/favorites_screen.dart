import 'package:flutter/material.dart';
import '../../../components/section_title.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: const Center(child: SectionTitle(text: 'Favorites Screen')),
    );
  }
}
