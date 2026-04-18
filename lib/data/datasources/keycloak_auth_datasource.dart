import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class KeycloakAuthDatasource {
  // Keycloak Configuration (from your Docker instance)
  static const String keycloakUrl =
      'https://mediconect-keycloak-etf8cqfwd3gqakcs.indonesiacentral-01.azurewebsites.net';
  static const String realm = 'mediconect';
  static const String clientId = 'mediconect-mobile';

  static const String _tokenEndpoint =
      '$keycloakUrl/realms/$realm/protocol/openid-connect/token';

  final Dio _dio = Dio();

  // In-memory tokens for development mode without extra storage packages.
  String? _accessToken;
  String? _refreshToken;
  String? _idToken;

  /// Authenticates with Keycloak using Direct Access Grants.
  Future<Map<String, dynamic>?> authenticate({
    required String identifier,
    required String password,
  }) async {
    final stopwatch = Stopwatch()..start();
    final startTime = DateTime.now();
    print('API_START: ${startTime.toIso8601String()}');

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _tokenEndpoint,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: {
          'grant_type': 'password',
          'client_id': clientId,
          'username': identifier,
          'password': password,
          'scope': 'openid profile email',
        },
      );

      stopwatch.stop();
      print('API_LATENCY: ${stopwatch.elapsedMilliseconds} ms');
      print('API_STATUS: ${response.statusCode}');

      final statusCode = response.statusCode ?? 500;
      if (statusCode < 200 || statusCode >= 300) {
        final errorJson = _coerceToMap(response.data);
        final error = errorJson['error']?.toString();

        if (statusCode == 401 || error == 'invalid_grant') {
          throw const KeycloakAuthException('invalid_credentials');
        }
        if (statusCode >= 500) {
          throw const KeycloakAuthException('server_unavailable');
        }
        throw const KeycloakAuthException('authentication_failed');
      }

      final data = _coerceToMap(response.data);
      _accessToken = data['access_token'] as String?;
      _refreshToken = data['refresh_token'] as String?;
      _idToken = data['id_token'] as String?;

      if (_idToken == null) {
        return null;
      }

      return _decodeJwtPayload(_idToken!);
    } on DioException catch (e) {
      if (stopwatch.isRunning) {
        stopwatch.stop();
      }
      print('API_ERROR: ${stopwatch.elapsedMilliseconds} ms - $e');

      final statusCode = e.response?.statusCode ?? 500;
      final errorJson = _coerceToMap(e.response?.data);
      final error = errorJson['error']?.toString();

      if (statusCode == 401 || error == 'invalid_grant') {
        throw const KeycloakAuthException('invalid_credentials');
      }
      if (statusCode >= 500) {
        throw const KeycloakAuthException('server_unavailable');
      }
      throw const KeycloakAuthException('authentication_failed');
    } catch (e) {
      if (stopwatch.isRunning) {
        stopwatch.stop();
      }
      print('API_ERROR: ${stopwatch.elapsedMilliseconds} ms - $e');
      debugPrint('Keycloak auth error: $e');
      rethrow;
    }
  }

  /// Retrieves the access token
  Future<String?> getAccessToken() async {
    return _accessToken;
  }

  /// Checks if token is expired
  Future<bool> isTokenExpired() async {
    final token = await getAccessToken();
    if (token == null) return true;
    try {
      final payload = _decodeJwtPayload(token);
      final exp = payload['exp'];
      if (exp is! num) return true;
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000);
      return DateTime.now().isAfter(expiry);
    } catch (_) {
      return true;
    }
  }

  /// Refreshes the access token
  Future<bool> refreshAccessToken() async {
    try {
      if (_refreshToken == null) return false;

      final response = await _dio.post<Map<String, dynamic>>(
        _tokenEndpoint,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
        data: {
          'grant_type': 'refresh_token',
          'client_id': clientId,
          'refresh_token': _refreshToken!,
        },
      );

      final statusCode = response.statusCode ?? 500;
      if (statusCode < 200 || statusCode >= 300) {
        return false;
      }

      final data = _coerceToMap(response.data);
      _accessToken = data['access_token'] as String?;
      _refreshToken = data['refresh_token'] as String? ?? _refreshToken;
      _idToken = data['id_token'] as String? ?? _idToken;
      return _accessToken != null;
    } catch (e) {
      debugPrint('Token refresh error: $e');
      return false;
    }
  }

  /// Logs out and clears tokens
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _idToken = null;
  }

  /// Retrieves stored user information
  Future<Map<String, dynamic>?> getUserInfo() async {
    if (_idToken == null) return null;

    try {
      return _decodeJwtPayload(_idToken!);
    } catch (e) {
      debugPrint('Error decoding user info: $e');
      return null;
    }
  }

  /// Checks if user is logged in
  Future<bool> hasActiveSession() async {
    final token = await getAccessToken();
    if (token == null) return false;
    return !await isTokenExpired();
  }

  Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length < 2) {
      throw const FormatException('Invalid JWT token format.');
    }

    final normalized = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  Map<String, dynamic> _tryDecodeJson(String input) {
    try {
      final data = jsonDecode(input);
      if (data is Map<String, dynamic>) {
        return data;
      }
    } catch (_) {}
    return <String, dynamic>{};
  }

  Map<String, dynamic> _coerceToMap(Object? input) {
    if (input is Map<String, dynamic>) {
      return input;
    }
    if (input is String) {
      return _tryDecodeJson(input);
    }
    return <String, dynamic>{};
  }
}

class KeycloakAuthException implements Exception {
  final String code;
  const KeycloakAuthException(this.code);

  @override
  String toString() => code;
}
