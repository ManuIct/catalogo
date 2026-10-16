import 'package:flutter/material.dart';

import '../../domain/model/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
    });

    final Product product;
    final bool isFavorite;
    final VoidCallback onTap;
    final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product.thumbnail,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrack) => 
               const SizedBox(width: 56, height: 56, child: Icon(Icons.image_not_supported),)
        ),
        ),
      title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${product.category} . \$${product.price.toStringAsFixed(2)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        tooltip: isFavorite ? 'Rimuovi dai preferiti' : 'Aggiungi ai preferiti',
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        color: isFavorite ? Theme.of(context).colorScheme.primary : null,
        onPressed: onToggleFavorite,
        ),
    );
  }
}