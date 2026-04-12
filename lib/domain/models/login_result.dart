import 'user_model.dart';

class LoginResult {
  final bool success;
  final UserModel? user;
  final String? errorMessage;

  const LoginResult.success(this.user)
      : success = true,
        errorMessage = null;

  const LoginResult.failure(this.errorMessage)
      : success = false,
        user = null;
}