import '../../../core/network/fhir_http_client.dart';

class FhirPatientRemoteDataSource {
  final FhirHttpClient _client;

  const FhirPatientRemoteDataSource(this._client);

  Future<Map<String, dynamic>> readPatientById(String patientId) {
    return _client.get('/Patient/$patientId');
  }

  Future<Map<String, dynamic>> searchPatients({
    String? family,
    String? given,
    String? identifier,
  }) {
    final query = <String, String>{};
    if (family != null && family.isNotEmpty) query['family'] = family;
    if (given != null && given.isNotEmpty) query['given'] = given;
    if (identifier != null && identifier.isNotEmpty) {
      query['identifier'] = identifier;
    }

    return _client.get('/Patient', query: query);
  }
}
