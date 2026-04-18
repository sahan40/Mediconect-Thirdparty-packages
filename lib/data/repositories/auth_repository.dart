import '../../domain/models/login_result.dart';
import '../../domain/models/user_model.dart';
import '../../domain/services/auth_service.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepository implements AuthService {
  final AuthLocalDataSource _localDataSource;

  AuthRepository({AuthLocalDataSource? localDataSource})
      : _localDataSource = localDataSource ?? AuthLocalDataSource();

  @override
  Future<LoginResult> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final userData = await _localDataSource.authenticate(
        identifier: identifier,
        password: password,
      );
      if (userData == null) {
        return const LoginResult.failure('Invalid email/phone or password.');
      }
      final user = UserModel.fromJson(userData);
      return LoginResult.success(user);
    } catch (e) {
      return LoginResult.failure('Login failed. Please try again.');
    }
  }

  @override
  Future<LoginResult> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const LoginResult.failure('Sign-up not implemented in this build.');
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearSession();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _localDataSource.hasActiveSession();
  }
}