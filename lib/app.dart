import 'package:dio_interceptors_loggers/auth/auth.dart';
import 'package:dio_interceptors_loggers/constants/environment.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.authRepo,
  });

  final AuthRepository authRepo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Environment.env == 'dev',
      title: 'Dio Demo',
      home: const Text('Hi'),
    );
  }
}
