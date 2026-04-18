class FhirEnvironment {
  FhirEnvironment._();

  static const String baseUrl = String.fromEnvironment(
    'FHIR_BASE_URL',
    defaultValue: 'http://localhost:8080/fhir',
  );

  static const bool smartAuthEnabled =
      String.fromEnvironment('FHIR_SMART_AUTH', defaultValue: 'false') ==
      'true';

  static const String authBaseUrl = String.fromEnvironment(
    'FHIR_AUTH_BASE_URL',
    defaultValue: '',
  );

  static const String clientId = String.fromEnvironment(
    'FHIR_CLIENT_ID',
    defaultValue: '',
  );

  static const String redirectUri = String.fromEnvironment(
    'FHIR_REDIRECT_URI',
    defaultValue: '',
  );

  static const String scope = String.fromEnvironment(
    'FHIR_SCOPE',
    defaultValue: 'openid profile offline_access patient/*.read',
  );

  static const bool useHttps =
      String.fromEnvironment('FHIR_USE_HTTPS', defaultValue: 'true') == 'true';

  static List<String> get missingKeys {
    final missing = <String>[];

    if (baseUrl.isEmpty) missing.add('FHIR_BASE_URL');
    if (smartAuthEnabled) {
      if (authBaseUrl.isEmpty) missing.add('FHIR_AUTH_BASE_URL');
      if (clientId.isEmpty) missing.add('FHIR_CLIENT_ID');
      if (redirectUri.isEmpty) missing.add('FHIR_REDIRECT_URI');
    }

    return missing;
  }

  static bool get isConfigured => missingKeys.isEmpty;
}
