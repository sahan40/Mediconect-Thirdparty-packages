import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_state.dart';

class SignupProvider {
  const SignupProvider._();

  static SignupState of(BuildContext context) {
    return context.watch<SignupState>();
  }
}

class SignupStateManager extends StatelessWidget {
  final Widget child;
  const SignupStateManager({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignupState>(
      create: (_) => SignupState(),
      child: child,
    );
  }
}
