import 'package:catalogo/features/favorites/ui/favorites_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> favoritesProviders() {
  return [
   ChangeNotifierProvider<FavoritesViewModel>(
    create: (_) => FavoritesViewModel(),
    ),
  ];
}