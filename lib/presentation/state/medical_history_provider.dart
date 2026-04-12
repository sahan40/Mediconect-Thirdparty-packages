import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medical_history_state.dart';

class MedicalHistoryProvider {
  const MedicalHistoryProvider._();

  static MedicalHistoryState of(BuildContext context) {
    return context.watch<MedicalHistoryState>();
  }
}

class MedicalHistoryStateManager extends StatelessWidget {
  final Widget child;
  const MedicalHistoryStateManager({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MedicalHistoryState>(
      create: (_) => MedicalHistoryState(),
      child: child,
    );
  }
}
