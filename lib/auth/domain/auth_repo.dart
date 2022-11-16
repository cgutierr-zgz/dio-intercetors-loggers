// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_interceptors_loggers/auth/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  AuthRepository({
    required AuthProvider authProvider,
    required FlutterSecureStorage flutterSecureStorage,
  }) {
    _authProvider = authProvider;
    _secureStorage = flutterSecureStorage;

    final client = authProvider.client;
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) async {
          // We add the accessToken to the headers if it's not null
          final accessToken = await _secureStorage.read(key: _accessTokenKey);

          if (accessToken != null) {
            request.headers['Authorization'] = 'Bearer $accessToken';
          }
          debugPrint('[DIO]: Added accessToken [${accessToken != null}]');

          return handler.next(request);
        },
        onError: (e, handler) async {
          // If the statuscode is 401 we try to refresh the token
          if (e.response?.statusCode == 401) {
            // We refresh the token
            await refreshTokens();

            // We add the accessToken to the headers if it's not null
            final accessToken = await _secureStorage.read(
              key: _accessTokenKey,
            );

            if (accessToken != null) {
              debugPrint('[DIO]: Refreshed Tokens');
              e.requestOptions.headers['Authorization'] = 'Bearer $accessToken';

              // Create request with new access token
              final opts = Options(
                method: e.requestOptions.method,
                headers: e.requestOptions.headers,
              );
              final cloneReq = await client.request<void>(
                e.requestOptions.path,
                options: opts,
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
              );

              return handler.resolve(cloneReq);
            }
            debugPrint("[DIO]: Couldn't refresh Tokens");
          }
        },
      ),
    );
  }

  late final AuthProvider _authProvider;
  late final FlutterSecureStorage _secureStorage;

  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _idTokenKey = 'ID_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  Future<User?> checkSession() async {
    final accessToken = await _secureStorage.read(key: _accessTokenKey);

    if (accessToken == null) return null;

    final user = await _getUserData();

    return user;
  }

  Future<User?> signIn() async {
    final response = await _authProvider.getAuthToken();

    if (response == null) return null;

    await _saveCredentials(
      accessToken: response.accessToken,
      idToken: response.idToken,
      refreshToken: response.refreshToken,
    );

    final user = await _getUserData();

    return user;
  }

  Future<User?> refreshTokens() async {
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
    if (refreshToken != null) {
      final response = await _authProvider.refreshTokens(refreshToken);

      if (response == null) return null;

      await _saveCredentials(
        accessToken: response.accessToken,
        idToken: response.idToken,
        refreshToken: response.refreshToken,
      );

      final user = await _getUserData();

      return user;
    }
    await deleteCredentials();
    return null;
  }

  Future<User> _getUserData() async {
    final response = await _authProvider.getUserDetails();

    final json = jsonDecode(jsonEncode(response.data)) as Map<String, dynamic>;
    final user = User.fromJson(json);

    return user;
  }

  Future<void> signOut() async {
    final idToken = await _secureStorage.read(key: _idTokenKey);
    await deleteCredentials();

    final response = await _authProvider.signOut(idToken!);

    debugPrint(response?.state);
  }

  Future<void> _saveCredentials({
    String? accessToken,
    String? idToken,
    String? refreshToken,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _idTokenKey, value: idToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> deleteCredentials() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _idTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }
}
