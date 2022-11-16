import 'package:dio_interceptors_loggers/dio_client.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hydated Storage Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String response;

  @override
  void initState() {
    super.initState();
    response = 'No response yet';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(response),
            TextButton(
              onPressed: () async {
                final data = await Pruebas.prueba();

                setState(() => response = data.toString());
              },
              child: const Text('test request'),
            )
          ],
        ),
      ),
    );
  }
}

class Pruebas {
  static Future<dynamic> prueba() async {
    final dio = DioClient();

    final response = await dio.get<dynamic>(
      'https://jsonplaceholder.typicode.com/todos/1',
    );

    return response.data;
  }
}
