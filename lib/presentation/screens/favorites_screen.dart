import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grupo_digital_test/presentation/provider/favorites_provider.dart';
import 'package:grupo_digital_test/presentation/views/favorites_view.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoritesProvider(),
      child: const Scaffold(body: FavoritesView()),
    );
  }
}
