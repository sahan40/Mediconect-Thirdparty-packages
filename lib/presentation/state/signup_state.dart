import 'package:flutter/foundation.dart';
import '../../domain/models/signup_model.dart';

enum SignupStatus { idle, loading, success, error }

class SignupState extends ChangeNotifier {
  SignupModel _form = const SignupModel();
  SignupStatus _status = SignupStatus.idle;
  String? _errorMessage;

  SignupModel get form => _form;
  SignupStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == SignupStatus.loading;

  void updateFullName(String value) {
    _form = _form.copyWith(fullName: value);
    notifyListeners();
  }

  void updateDateOfBirth(DateTime value) {
    _form = _form.copyWith(dateOfBirth: value);
    notifyListeners();
  }

  void updatePassword(String value) {
    _form = _form.copyWith(password: value);
    notifyListeners();
  }

  void updateBloodType(String value) {
    _form = _form.copyWith(bloodType: value);
    notifyListeners();
  }

  void updateAllergies(String value) {
    _form = _form.copyWith(knownAllergies: value);
    notifyListeners();
  }

  void updateContactName(String value) {
    _form = _form.copyWith(contactName: value);
    notifyListeners();
  }

  void updateRelationship(String value) {
    _form = _form.copyWith(relationship: value);
    notifyListeners();
  }

  Future<bool> submitStep() async {
    if (_form.fullName.trim().isEmpty) {
      _errorMessage = 'Full name is required.';
      _status = SignupStatus.error;
      notifyListeners();
      return false;
    }
    if (_form.dateOfBirth == null) {
      _errorMessage = 'Date of birth is required.';
      _status = SignupStatus.error;
      notifyListeners();
      return false;
    }
    if (_form.password.trim().length < 6) {
      _errorMessage = 'Password must be at least 6 characters.';
      _status = SignupStatus.error;
      notifyListeners();
      return false;
    }
    _status = SignupStatus.loading;
    _errorMessage = null;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _status = SignupStatus.success;
    notifyListeners();
    return true;
  }

  void clearError() {
    _errorMessage = null;
    _status = SignupStatus.idle;
    notifyListeners();
  }
}
