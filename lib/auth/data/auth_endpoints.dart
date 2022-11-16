// ignore_for_file: lines_longer_than_80_chars

import 'package:dio_interceptors_loggers/constants/environment.dart';

abstract class AuthEndpoints {
  // OAuth 2.0
  static const _tenantID = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';
  static const _oAuthBaseUrl = 'https://login.microsoftonline.com/$_tenantID';
  static final _env = Environment.env.toLowerCase();
  static final _redirectEnv = _env == 'prod' ? '' : _env == 'uat' ? 'uat' : 'dev';
  static final redirectUrl = 'com.domain.app$_redirectEnv://oauth/';
  static const authEndpoint = '$_oAuthBaseUrl/oauth2/v2.0/authorize';
  static const tokenEndpoint = '$_oAuthBaseUrl/oauth2/v2.0/token';
  static const openIDMetadataEndpoint = '$_oAuthBaseUrl/v2.0/.well-known/openid-configuration';
  static const scopes = ['openid', 'profile', 'offline_access'];

  // Microsoft Graph API
  static const _microsoftGraphApiBaseUrl = 'https://graph.microsoft.com';

  static const userInfoEndpoint = '$_microsoftGraphApiBaseUrl/oidc/userinfo';
  static const endSessionEndpoint = '$_microsoftGraphApiBaseUrl/v1.0/me/revokeSignInSessions';
}
