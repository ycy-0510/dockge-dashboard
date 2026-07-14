import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return FlutterSecureStorage();
}

final class SecureTokenStore {
  const SecureTokenStore(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> readToken() => _storage.read(key: SecureStorageKey.token);

  Future<void> writeToken(String token) =>
      _storage.write(key: SecureStorageKey.token, value: token);

  Future<void> deleteToken() => _storage.delete(key: SecureStorageKey.token);
}

@Riverpod(keepAlive: true)
SecureTokenStore secureTokenStore(Ref ref) => SecureTokenStore(ref.watch(secureStorageProvider));

abstract final class SecureStorageKey {
  static const token = "token";
}
