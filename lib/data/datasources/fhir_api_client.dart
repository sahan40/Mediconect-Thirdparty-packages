import 'dart:convert';

import 'package:dio/dio.dart';

class FhirApiClient {
  final String baseUrl;
  final Dio _dio;

  FhirApiClient({required this.baseUrl, Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              responseType: ResponseType.json,
              headers: const {
                'Accept': 'application/fhir+json',
                'Content-Type': 'application/fhir+json',
              },
            ),
          );

  Future<Map<String, dynamic>> getJson(String resourcePath) async {
    final response = await _dio.get<Object?>(resourcePath);
    final statusCode = response.statusCode ?? 500;

    if (statusCode < 200 || statusCode >= 300) {
      throw Exception(
        'FHIR request failed ($statusCode) for $baseUrl$resourcePath',
      );
    }

    final raw = response.data;
    final decoded = raw is String ? jsonDecode(raw) : raw;
    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Unexpected FHIR response format for $baseUrl$resourcePath',
      );
    }
    return decoded;
  }

  void dispose() {
    _dio.close(force: true);
  }
}
