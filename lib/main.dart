import 'package:dio_interceptors_loggers/app.dart';
import 'package:dio_interceptors_loggers/auth/auth.dart';
import 'package:dio_interceptors_loggers/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  final client = DioClient();
  const securedStorage = FlutterSecureStorage();
  const appAuth = FlutterAppAuth();

  final authProvider = AuthProvider(
    client: client,
    flutterAppAuth: appAuth,
  );

  final authRepo = AuthRepository(
    authProvider: authProvider,
    flutterSecureStorage: securedStorage,
  );

  // Obviously you'd pass this as a RepositoryProvider
  // for example, depending on your architecture
  runApp(MyApp(authRepo: authRepo));
}
