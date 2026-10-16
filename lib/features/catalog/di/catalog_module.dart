import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import'../data/repository/product_repository_impl.dart';
import '../data/source/product_remote_source.dart';
import '../domain/repository/product_repository.dart';

List<SingleChildWidget> catalogProviders() => [
    Provider<ProductRemoteSource>(
      create: (ctx) => ProductRemoteSource(ctx.read<Dio>()),
      ),
    Provider<ProductRepository>(
      create: (ctx) => ProductRepositoryImpl(ctx.read<ProductRemoteSource>()),
      ),
];
