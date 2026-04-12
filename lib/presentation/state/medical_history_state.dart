import 'package:flutter/foundation.dart';
import '../../domain/models/medical_history_model.dart';

enum MedicalHistoryStatus { idle, loading, success, error }

class MedicalHistoryState extends ChangeNotifier {
  MedicalHistoryModel _form = const MedicalHistoryModel();
  MedicalHistoryStatus _status = MedicalHistoryStatus.idle;
  String? _errorMessage;

  // Pre-loaded default medication items (as shown in screenshot)
  MedicalHistoryState() {
    _form = MedicalHistoryModel(
      chronicConditions: [],
      pastSurgeries: '',
      medications: [
        MedicationItem(
          id: '1',
          name: 'Metformin',
          dosage: '500mg',
          frequency: 'Twice daily',
        ),
        MedicationItem(
          id: '2',
          name: 'Lisinopril',
          dosage: '10mg',
          frequency: 'Once daily',
        ),
      ],
    );
  }

  MedicalHistoryModel get form => _form;
  MedicalHistoryStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == MedicalHistoryStatus.loading;

  // ── Chronic Conditions ──────────────────────────────────
  void toggleCondition(String condition) {
    final current = List<String>.from(_form.chronicConditions);
    if (condition == 'None') {
      // Selecting "None" clears all others
      _form = _form.copyWith(
        chronicConditions: current.contains('None') ? [] : ['None'],
      );
    } else {
      // Remove "None" if a real condition is selected
      current.remove('None');
      if (current.contains(condition)) {
        current.remove(condition);
      } else {
        current.add(condition);
      }
      _form = _form.copyWith(chronicConditions: current);
    }
    notifyListeners();
  }

  bool isConditionSelected(String condition) {
    return _form.chronicConditions.contains(condition);
  }

  void updatePastSurgeries(String value) {
    _form = _form.copyWith(pastSurgeries: value);
    notifyListeners();
  }

  void addMedication({
    required String name,
    required String dosage,
    required String frequency,
  }) {
    final updated = List<MedicationItem>.from(_form.medications);
    updated.add(
      MedicationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        dosage: dosage,
        frequency: frequency,
      ),
    );
    _form = _form.copyWith(medications: updated);
    notifyListeners();
  }

  void removeMedication(String id) {
    final updated = _form.medications.where((m) => m.id != id).toList();
    _form = _form.copyWith(medications: updated);
    notifyListeners();
  }

  // ── Submit ───────────────────────────────────────────────
  Future<bool> submitStep() async {
    if (_form.chronicConditions.isEmpty) {
      _errorMessage = 'Please select at least one condition.';
      _status = MedicalHistoryStatus.error;
      notifyListeners();
      return false;
    }

    if (_form.pastSurgeries.trim().isEmpty) {
      _errorMessage = 'Please enter past surgeries or hospitalizations.';
      _status = MedicalHistoryStatus.error;
      notifyListeners();
      return false;
    }

    if (_form.medications.isEmpty) {
      _errorMessage = 'Please add at least one medication.';
      _status = MedicalHistoryStatus.error;
      notifyListeners();
      return false;
    }

    _status = MedicalHistoryStatus.loading;
    _errorMessage = null;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _status = MedicalHistoryStatus.success;
    notifyListeners();
    return true;
  }

  void clearError() {
    _errorMessage = null;
    _status = MedicalHistoryStatus.idle;
    notifyListeners();
  }
}
