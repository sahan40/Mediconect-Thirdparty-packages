import '../models/login_result.dart';

abstract class AuthService {
  Future<LoginResult> login({
    required String identifier,
    required String password,
  });

  Future<LoginResult> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<bool> isLoggedIn();
}