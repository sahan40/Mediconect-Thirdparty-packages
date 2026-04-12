import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_state.dart';

class LoginProvider {
  final LoginState state;

  const LoginProvider._(this.state);

  static LoginProvider of(BuildContext context) {
    return LoginProvider._(context.watch<LoginState>());
  }
}

class LoginStateManager extends StatelessWidget {
  final Widget child;
  const LoginStateManager({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (_) => LoginState(),
      child: child,
    );
  }
}
