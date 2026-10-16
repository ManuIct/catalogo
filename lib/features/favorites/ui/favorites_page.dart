import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../catalog/ui/widgets/product_tile.dart';
import 'favorites_view_model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesViewModel>();
    final list = favorites.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Preferiti')),
      body: list.isEmpty
          ? const Center(child: Text('Nessun preferito'))
          : ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = list[index];
                return ProductTile(
                  product: product,
                  isFavorite: true,
                  onTap: () => context.push('/prodotto/${product.id}'),
                  onToggleFavorite: () => favorites.toggle(product),
                );
              },
            ),
    );
  }
}
