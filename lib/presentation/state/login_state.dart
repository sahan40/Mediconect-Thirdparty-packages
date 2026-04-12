import 'package:flutter/foundation.dart';
import '../../domain/models/user_model.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/validation_service.dart';
import '../../data/repositories/keycloak_auth_repository.dart';

enum LoginStatus { idle, loading, success, error }

class LoginState extends ChangeNotifier {
  final AuthService _authService;

  LoginState({AuthService? authService})
    : _authService = authService ?? KeycloakAuthRepository();

  LoginStatus _status = LoginStatus.idle;
  bool _obscurePassword = true;
  String? _errorMessage;
  UserModel? _user;

  LoginStatus get status => _status;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;
  bool get isLoading => _status == LoginStatus.loading;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _status = LoginStatus.idle;
    notifyListeners();
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    final identifierError = ValidationService.validateIdentifier(identifier);
    if (identifierError != null) {
      _errorMessage = identifierError;
      _status = LoginStatus.error;
      notifyListeners();
      return false;
    }

    final passwordError = ValidationService.validatePassword(password);
    if (passwordError != null) {
      _errorMessage = passwordError;
      _status = LoginStatus.error;
      notifyListeners();
      return false;
    }

    _status = LoginStatus.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.login(
      identifier: identifier,
      password: password,
    );

    if (result.success) {
      _user = result.user;
      _status = LoginStatus.success;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result.errorMessage;
      _status = LoginStatus.error;
      notifyListeners();
      return false;
    }
  }
}
