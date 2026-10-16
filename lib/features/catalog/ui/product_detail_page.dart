import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_detail_view_model.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductDetailViewModel>();

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (vm.error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(vm.error!)),
      );      
    }
    final product = vm.product;
    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Prodotto non trovato')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.thumbnail,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Text(product.description),
              const SizedBox(height: 16),
              Text('Categoria: ${product.category}'),
              Text('Valutazione: ${product.rating}'),
              Text('Disponibilità: ${product.stock}'),
          ],
        ),
      ),
    );
  }
}
