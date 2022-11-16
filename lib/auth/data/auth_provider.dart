import 'package:dio/dio.dart';
import 'package:dio_interceptors_loggers/auth/auth.dart';
import 'package:dio_interceptors_loggers/constants/environment.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class AuthProvider {
  AuthProvider({
    required this.client,
    required FlutterAppAuth flutterAppAuth,
  }) {
    _flutterAppAuth = flutterAppAuth;
    _authorizationServiceConfig = const AuthorizationServiceConfiguration(
      authorizationEndpoint: AuthEndpoints.authEndpoint,
      tokenEndpoint: AuthEndpoints.tokenEndpoint,
      endSessionEndpoint: AuthEndpoints.endSessionEndpoint,
    );
  }

  late final FlutterAppAuth _flutterAppAuth;
  late final Dio client;
  late final AuthorizationServiceConfiguration _authorizationServiceConfig;

  Future<AuthorizationTokenResponse?> getAuthToken() async {
    final response = await _flutterAppAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        Environment.clientID,
        AuthEndpoints.redirectUrl,
        discoveryUrl: AuthEndpoints.openIDMetadataEndpoint,
        serviceConfiguration: _authorizationServiceConfig,
        scopes: AuthEndpoints.scopes,
      ),
    );

    return response;
  }

  Future<TokenResponse?> refreshTokens(String refreshToken) async {
    final response = await _flutterAppAuth.token(
      TokenRequest(
        Environment.clientID,
        AuthEndpoints.redirectUrl,
        discoveryUrl: AuthEndpoints.openIDMetadataEndpoint,
        refreshToken: refreshToken,
        scopes: AuthEndpoints.scopes,
      ),
    );

    return response;
  }

  Future<EndSessionResponse?> signOut(String idToken) async {
    final response = await _flutterAppAuth.endSession(
      EndSessionRequest(
        idTokenHint: idToken,
        serviceConfiguration: _authorizationServiceConfig,
        postLogoutRedirectUrl: AuthEndpoints.redirectUrl,
      ),
    );

    return response;
  }

  Future<Response<dynamic>> getUserDetails() async {
    final response = await client.get<void>(AuthEndpoints.userInfoEndpoint);

    return response;
  }
}
