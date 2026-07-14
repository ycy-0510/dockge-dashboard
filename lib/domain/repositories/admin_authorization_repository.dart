abstract interface class AdminAuthorizationRepository {
  Future<bool> authorize();
}

class AdminAuthorizationException implements Exception {
  const AdminAuthorizationException(this.message);

  final String message;

  @override
  String toString() => message;
}
