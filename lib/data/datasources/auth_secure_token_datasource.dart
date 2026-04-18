class AuthTokens {
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  const AuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });
}

class AuthSecureTokenDataSource {
  static const _accessTokenKey = 'auth.access_token';
  static const _refreshTokenKey = 'auth.refresh_token';
  static const _expiresAtKey = 'auth.expires_at';

  static final Map<String, String> _memoryStore = <String, String>{};

  const AuthSecureTokenDataSource();

  Future<void> saveTokens(AuthTokens tokens) async {
    _memoryStore[_accessTokenKey] = tokens.accessToken;
    if (tokens.refreshToken != null) {
      _memoryStore[_refreshTokenKey] = tokens.refreshToken!;
    } else {
      _memoryStore.remove(_refreshTokenKey);
    }
    if (tokens.expiresAt != null) {
      _memoryStore[_expiresAtKey] = tokens.expiresAt!.toIso8601String();
    } else {
      _memoryStore.remove(_expiresAtKey);
    }
  }

  Future<AuthTokens?> readTokens() async {
    final accessToken = _memoryStore[_accessTokenKey];
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    final refreshToken = _memoryStore[_refreshTokenKey];
    final expiresAtRaw = _memoryStore[_expiresAtKey];

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAtRaw == null ? null : DateTime.tryParse(expiresAtRaw),
    );
  }

  Future<String?> readAccessToken() async {
    return _memoryStore[_accessTokenKey];
  }

  Future<void> clearTokens() async {
    _memoryStore.remove(_accessTokenKey);
    _memoryStore.remove(_refreshTokenKey);
    _memoryStore.remove(_expiresAtKey);
  }
}
