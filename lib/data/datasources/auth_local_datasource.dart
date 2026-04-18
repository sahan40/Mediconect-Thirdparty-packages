class AuthLocalDataSource {
  static const Map<String, String> _mockCredentials = {
    'user@health.com': 'pass123',
    '+94771234567':    'pass123',
  };

  static const Map<String, Map<String, String>> _mockUsers = {
    'user@health.com': {
      'id':       'usr_001',
      'email':    'user@health.com',
      'fullName': 'John Smith',
      'phone':    '+94771234567',
    },
  };

  Future<Map<String, dynamic>?> authenticate({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final stored = _mockCredentials[identifier.trim()];
    if (stored == null || stored != password) return null;
    return Map<String, dynamic>.from(
      _mockUsers[identifier.trim()] ?? _mockUsers['user@health.com']!,
    );
  }

  Future<bool> hasActiveSession() async => false;

  Future<void> clearSession() async {}
}