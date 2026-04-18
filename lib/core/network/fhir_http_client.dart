import 'dart:convert';

import 'package:dio/dio.dart';

class FhirHttpException implements Exception {
  final int statusCode;
  final String message;

  const FhirHttpException({required this.statusCode, required this.message});

  @override
  String toString() => 'FhirHttpException($statusCode): $message';
}

class FhirHttpClient {
  final Dio _dio;
  final String _baseUrl;
  final Future<String?> Function()? _getAccessToken;

  FhirHttpClient({
    required String baseUrl,
    Dio? dio,
    Future<String?> Function()? getAccessToken,
  }) : _baseUrl = baseUrl.replaceAll(RegExp(r'/+$'), ''),
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl.replaceAll(RegExp(r'/+$'), ''),
               responseType: ResponseType.json,
             ),
           ),
       _getAccessToken = getAccessToken;

  Uri _buildUri(String path, [Map<String, String>? query]) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$_baseUrl$normalizedPath');
    if (query == null || query.isEmpty) return uri;
    return uri.replace(queryParameters: query);
  }

  Future<Map<String, String>> _headers() async {
    final headers = <String, String>{
      'Accept': 'application/fhir+json',
      'Content-Type': 'application/fhir+json',
    };

    final token = await _getAccessToken?.call();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
  }) async {
    try {
      final response = await _dio.get<Object?>(
        _buildUri(path, query).toString(),
        options: Options(headers: await _headers()),
      );
      return _decode(response.statusCode ?? 500, response.data);
    } on DioException catch (e) {
      throw _decodeError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post<Object?>(
        _buildUri(path).toString(),
        data: jsonEncode(body),
        options: Options(headers: await _headers()),
      );
      return _decode(response.statusCode ?? 500, response.data);
    } on DioException catch (e) {
      throw _decodeError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.put<Object?>(
        _buildUri(path).toString(),
        data: jsonEncode(body),
        options: Options(headers: await _headers()),
      );
      return _decode(response.statusCode ?? 500, response.data);
    } on DioException catch (e) {
      throw _decodeError(e);
    }
  }

  Map<String, dynamic> _decode(int statusCode, Object? data) {
    final decoded = _coerceJson(data);

    if (statusCode < 200 || statusCode >= 300) {
      throw FhirHttpException(
        statusCode: statusCode,
        message: decoded['issue']?.toString() ?? 'HTTP error',
      );
    }

    return decoded;
  }

  Map<String, dynamic> _coerceJson(Object? data) {
    if (data == null) {
      return <String, dynamic>{};
    }
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is String && data.isNotEmpty) {
      final parsed = jsonDecode(data);
      if (parsed is Map<String, dynamic>) {
        return parsed;
      }
    }
    throw const FhirHttpException(
      statusCode: 500,
      message: 'FHIR response is not a JSON object.',
    );
  }

  FhirHttpException _decodeError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode ?? 500;
    try {
      final decoded = _coerceJson(response?.data);
      return FhirHttpException(
        statusCode: statusCode,
        message: decoded['issue']?.toString() ?? error.message ?? 'HTTP error',
      );
    } on FhirHttpException {
      return FhirHttpException(
        statusCode: statusCode,
        message: error.message ?? 'HTTP error',
      );
    }
  }

  void dispose() {
    _dio.close(force: true);
  }
}
