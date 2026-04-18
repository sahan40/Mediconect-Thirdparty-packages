import '../../../core/network/fhir_http_client.dart';

class FhirMetadataRemoteDataSource {
  final FhirHttpClient _client;

  const FhirMetadataRemoteDataSource(this._client);

  Future<Map<String, dynamic>> fetchCapabilityStatement() {
    return _client.get('/metadata');
  }
}
