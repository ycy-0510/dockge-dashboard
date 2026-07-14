import 'package:dockge_dashboard/core/storage/prefs.dart';
import 'package:dockge_dashboard/core/storage/secure_storage.dart';
import 'package:dockge_dashboard/data/services/dockge_api_service.dart';
import 'package:dockge_dashboard/domain/repositories/auth_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dockge_auth_repository.g.dart';

final class DockgeAuthRepository implements AuthRepository {
  const DockgeAuthRepository({
    required DockgeApiService api,
    required PrefsStore preferences,
    required SecureTokenStore secureTokens,
  }) : this._(api, preferences, secureTokens);

  const DockgeAuthRepository._(
    this._api,
    this._preferences,
    this._secureTokens,
  );

  final DockgeApiService _api;
  final PrefsStore _preferences;
  final SecureTokenStore _secureTokens;

  @override
  Future<String> login({
    required String endpoint,
    required String username,
    required String password,
  }) async {
    final result = await _api.login(username: username, password: password);
    if (!result.isSuccessful) {
      throw StateError(result.message ?? 'Login failed');
    }
    final token = result.token;
    if (token == null || token.isEmpty) {
      throw StateError('The server did not return an authentication token');
    }
    await _secureTokens.writeToken(token);
    await _preferences.writeEndpoint(endpoint);
    return username;
  }

  @override
  Future<String?> loginWithSavedToken() async {
    final token = await _secureTokens.readToken();
    if (token == null) return null;

    final String username;
    try {
      final payload = JwtDecoder.decode(token);
      final value = payload['username'];
      if (value is! String || value.isEmpty) {
        throw const FormatException('JWT username is missing');
      }
      username = value;
    } on Object {
      await _secureTokens.deleteToken();
      return null;
    }

    final result = await _api.loginWithToken(token);
    if (!result.isSuccessful) {
      throw StateError(result.message ?? 'Token login failed');
    }
    return username;
  }

  @override
  Future<void> logout() async {
    await _secureTokens.deleteToken();
    _api.logout();
  }
}

@riverpod
AuthRepository authRepository(Ref ref) => DockgeAuthRepository(
  api: ref.watch(dockgeApiServiceProvider),
  preferences: ref.watch(prefsStoreProvider),
  secureTokens: ref.watch(secureTokenStoreProvider),
);
