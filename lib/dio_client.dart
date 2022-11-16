import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class Environment {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
}

class DioClient extends DioForNative {
  DioClient({
    List<Interceptor>? interceptors,
    BaseOptions? options,
    int timeOutInMilliseconds = 30 * 1000,
  }) : super(
          options ??
              BaseOptions(
                connectTimeout: timeOutInMilliseconds,
                sendTimeout: timeOutInMilliseconds,
                receiveTimeout: timeOutInMilliseconds,
              ),
        ) {
    this.interceptors.addAll(
      [
        // Whatever interceptors you want to add
        ...?interceptors,
        // Retry Interceptor
        RetryInterceptor(dio: this, logPrint: print),

        // Network Logger interceptor only for debug mode
        if (kDebugMode) ...[
          // Pretty Dio Logger from https://pub.dev/packages/pretty_dio_logger
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            // ... other options
          ),

          // Our Custom Logger from below :D
          LoggerInterceptor()
        ]
      ],
    );
  }
}

class LoggerInterceptor extends LogInterceptor {
  LoggerInterceptor()
      : super(
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          logPrint: (log) {
            if (kDebugMode == false) return;

            debugPrint('🌐 ${log.toString()}');
          },
        );
}
