abstract interface class AuthRepository {
  Future<String> login({
    required String endpoint,
    required String username,
    required String password,
  });

  Future<String?> loginWithSavedToken();

  Future<void> logout();
}
