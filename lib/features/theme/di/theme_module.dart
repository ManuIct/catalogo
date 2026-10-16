import 'package:catalogo/features/theme/ui/theme_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> themeProviders() {
  return [
    ChangeNotifierProvider(
    create: (_) => ThemeViewModel()
    )
    ];
}
