import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:catalogo/features/favorites/ui/favorites_view_model.dart';
import 'package:catalogo/features/theme/ui/theme_toggle_button.dart';
import 'catalog_view_model.dart';
import 'widgets/product_tile.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CatalogViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogo'),
        actions: [
          IconButton(
            tooltip: 'Preferiti',
            icon: const Icon(Icons.favorite_border),
            onPressed: () => context.push('/preferiti'),
          ),
          const ThemeToggleButton(),
          IconButton(
            tooltip: 'Profilo',
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profilo'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: vm.onQueryChanged,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Cerca un prodotto...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          if (vm.isLoading && vm.products.isNotEmpty)
            const LinearProgressIndicator(),
          Expanded(child: _CatalogBody(vm: vm)),
        ],
      ),
    );
  }
}

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({required this.vm});

  final CatalogViewModel vm;

  @override
  Widget build(BuildContext context) {
    if (vm.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(vm.error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                // Assicurati che nel tuo CatalogViewModel il metodo si chiami 'loadProducts' (minuscolo)
                onPressed: vm.loadProducts, 
                child: const Text('Riprova'),
              ),
            ],
          ),
        ),
      );
    }
    if (vm.isLoading && vm.products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (vm.products.isEmpty) {
      return const Center(child: Text('Nessun prodotto trovato'));
    }
    final favorites = context.watch<FavoritesViewModel>();
    return ListView.separated(
      itemCount: vm.products.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final product = vm.products[index];
        return ProductTile(
          product: product,
          isFavorite: favorites.isFavorite(product.id),
          onTap: () => context.push('/prodotto/${product.id}'),
          onToggleFavorite: () => favorites.toggle(product),
        );
      },
    );
  }
}