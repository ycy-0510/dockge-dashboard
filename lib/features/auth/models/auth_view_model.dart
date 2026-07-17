import 'dart:developer';

import 'package:dockge_dashboard/app/core/network/dockge_client.dart';
import 'package:dockge_dashboard/app/shared/toast/toast_notifier.dart';
import 'package:dockge_dashboard/app/core/storage/prefs.dart';
import 'package:dockge_dashboard/features/auth/services/dockge_auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.freezed.dart';
part 'auth_view_model.g.dart';

enum LoginStatus { loading, authenticated, unauthenticated }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    required LoginStatus loginStatus,
    String? username,
  }) = _AuthState;
}

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthState build() {
    ref.listen(dockgeClientProvider, (previous, next) {
      final previousStatus = previous?.status;
      final nextStatus = next.status;
      if (nextStatus == SocketStatus.connected &&
          previousStatus != SocketStatus.connected &&
          (state.loginStatus == LoginStatus.loading ||
              state.loginStatus == LoginStatus.authenticated)) {
        Future<void>.microtask(loginWithToken);
      } else if (nextStatus == SocketStatus.disconnected &&
          state.loginStatus == LoginStatus.loading) {
        state = const AuthState(loginStatus: .unauthenticated);
      }
    });
    final endpoint = ref.read(prefsStoreProvider).readEndpoint();
    return AuthState(
      loginStatus: endpoint == null ? .unauthenticated : .loading,
    );
  }

  void setUnauthenticated() {
    state = state.copyWith(loginStatus: .unauthenticated);
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(loginStatus: .loading);
    final connected = await ref.read(dockgeClientProvider.notifier).waitForConnect();
    final endpoint = ref.read(dockgeClientProvider).endpoint;
    if (!connected || endpoint == null) {
      _fail('Connection error');
      return;
    }

    try {
      final authenticatedUsername = await ref
          .read(authRepositoryProvider)
          .login(endpoint: endpoint, username: username, password: password);
      if (!ref.mounted) return;
      state = AuthState(
        username: authenticatedUsername,
        loginStatus: .authenticated,
      );
    } catch (error, stackTrace) {
      _logFailure(error, stackTrace);
      if (ref.mounted) _fail(_message(error, 'Login failed'));
    }
  }

  Future<void> loginWithToken() async {
    state = state.copyWith(loginStatus: .loading);
    try {
      final username = await ref.read(authRepositoryProvider).loginWithSavedToken();
      if (!ref.mounted) return;
      state = username == null
          ? const AuthState(loginStatus: .unauthenticated)
          : AuthState(username: username, loginStatus: .authenticated);
    } catch (error, stackTrace) {
      _logFailure(error, stackTrace);
      if (ref.mounted) _fail(_message(error, 'Token login failed'));
    }
  }

  Future<void> logout() async {
    state = const AuthState(loginStatus: .unauthenticated);
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (error, stackTrace) {
      _logFailure(error, stackTrace);
      if (ref.mounted) {
        ref
            .read(toastProvider.notifier)
            .showError(message: 'Failed to clear authentication: $error');
      }
    }
  }

  void _fail(String message) {
    state = const AuthState(loginStatus: .unauthenticated);
    ref.read(toastProvider.notifier).showError(message: message);
  }

  void _logFailure(Object error, StackTrace stackTrace) => log(
    'Authentication failed',
    name: 'AuthViewModel',
    error: error,
    stackTrace: stackTrace,
  );

  String _message(Object error, String fallback) {
    if (error case StateError(:final message)) return message.toString();
    return fallback;
  }
}
