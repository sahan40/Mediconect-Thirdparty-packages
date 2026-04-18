import '../core/config/fhir_environment.dart';
import '../core/network/fhir_http_client.dart';
import 'datasources/auth_secure_token_datasource.dart';
import 'datasources/fhir/fhir_metadata_remote_datasource.dart';
import 'datasources/fhir/fhir_patient_remote_datasource.dart';

class FhirIntegrationBootstrap {
  final AuthSecureTokenDataSource tokenDataSource;
  final FhirHttpClient httpClient;
  final FhirMetadataRemoteDataSource metadataDataSource;
  final FhirPatientRemoteDataSource patientDataSource;

  const FhirIntegrationBootstrap._({
    required this.tokenDataSource,
    required this.httpClient,
    required this.metadataDataSource,
    required this.patientDataSource,
  });

  factory FhirIntegrationBootstrap.create() {
    if (!FhirEnvironment.isConfigured) {
      final missing = FhirEnvironment.missingKeys.join(', ');
      throw StateError('FHIR environment is not configured. Missing: $missing');
    }

    final tokenDataSource = const AuthSecureTokenDataSource();
    final httpClient = FhirHttpClient(
      baseUrl: FhirEnvironment.baseUrl,
      getAccessToken: tokenDataSource.readAccessToken,
    );

    return FhirIntegrationBootstrap._(
      tokenDataSource: tokenDataSource,
      httpClient: httpClient,
      metadataDataSource: FhirMetadataRemoteDataSource(httpClient),
      patientDataSource: FhirPatientRemoteDataSource(httpClient),
    );
  }
}
