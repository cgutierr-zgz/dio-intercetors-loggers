
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
        RetryInterceptor(
          dio: this,
          logPrint: print,

        ),

        // Network Logger interceptor only for debug mode
        if (kDebugMode) ...[
          // Base Log interceptor
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            // ... other options
            requestHeader: false,
            responseHeader: false,
            error: false,
            request: false,
            logPrint: (log) {
              if (log.toString().isEmpty) return;
              debugPrint('🌐 ${log.toString()}');
            },
          ),

          // Pretty Dio Logger from https://pub.dev/packages/pretty_dio_logger
          PrettyDioLogger(
            requestBody: true,
            responseBody: true,
            // ... other options
            requestHeader: false,
            responseHeader: false,
            error: false,
            request: false,
          ),
        ]
      ],
    );
  }
}
