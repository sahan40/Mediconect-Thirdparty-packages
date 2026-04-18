import '../../domain/models/login_result.dart';
import '../../domain/models/user_model.dart';
import '../../domain/services/auth_service.dart';
import '../datasources/keycloak_auth_datasource.dart';

class KeycloakAuthRepository implements AuthService {
  final KeycloakAuthDatasource _datasource;

  KeycloakAuthRepository({KeycloakAuthDatasource? datasource})
    : _datasource = datasource ?? KeycloakAuthDatasource();

  @override
  Future<LoginResult> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final userInfo = await _datasource.authenticate(
        identifier: identifier,
        password: password,
      );

      if (userInfo == null) {
        return const LoginResult.failure('Login cancelled or failed.');
      }

      // Parse user info from Keycloak
      final user = _keycloakUserToModel(userInfo);
      return LoginResult.success(user);
    } on KeycloakAuthException catch (e) {
      return LoginResult.failure(_friendlyMessageFor(e.code));
    } catch (e) {
      return const LoginResult.failure(
        'Unable to sign in right now. Please try again.',
      );
    }
  }

  @override
  Future<LoginResult> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // Keycloak handles registration through its built-in registration page
    // This is typically triggered via the registration link or registration endpoint
    try {
      // In a full implementation, you would make an HTTP call to Keycloak's
      // user registration endpoint or trigger registration page
      return LoginResult.failure(
        'Use Keycloak registration page or admin console.',
      );
    } catch (e) {
      return LoginResult.failure('Signup not available: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await _datasource.logout();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _datasource.hasActiveSession();
  }

  /// Convert Keycloak JWT claims to UserModel
  UserModel _keycloakUserToModel(Map<String, dynamic> keycloakClaims) {
    return UserModel(
      id: keycloakClaims['sub'] ?? 'unknown_id',
      email: keycloakClaims['email'] ?? '',
      fullName:
          keycloakClaims['name'] ?? keycloakClaims['preferred_username'] ?? '',
      phone: keycloakClaims['phone_number'] ?? '',
    );
  }

  String _friendlyMessageFor(String code) {
    switch (code) {
      case 'invalid_credentials':
        return 'Incorrect email/phone or password. Please try again.';
      case 'server_unavailable':
        return 'Authentication service is temporarily unavailable. Please try again in a moment.';
      default:
        return 'Unable to sign in. Please check your details and try again.';
    }
  }
}
