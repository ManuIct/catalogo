import 'package:dio/dio.dart';

const String requiresAuthkey = 'requiresAuth';

const String retriedKey = 'authRetried';

class AuthOptions {
  const AuthOptions._();

  static Options protected() => Options(extra: {requiresAuthkey: true});
}