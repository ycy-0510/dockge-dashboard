import 'dart:async';

import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/core/providers/toast_notifier.dart';
import 'package:dockge_dashboard/core/storage/prefs.dart';
import 'package:dockge_dashboard/core/storage/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.freezed.dart';
part 'auth_controller.g.dart';

enum LoginStatus { loading, authenticated, unauthenticated }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({required LoginStatus loginStatus, String? username}) = _AuthState;
}

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    final endpoint = ref.read(prefsProvider).getString(PrefsKey.endpoint);
    if (endpoint != null) {
      return AuthState(loginStatus: .loading);
    }
    return AuthState(loginStatus: .unauthenticated);
  }

  void setUnauthenticated() {
    state = state.copyWith(loginStatus: .unauthenticated);
  }

  Future<void> login({required String username, required String password}) async {
    state = state.copyWith(loginStatus: .loading);
    await _authenticate(
      event: "login",
      data: {"username": username, "password": password},
      onSuccess: (res) async {
        await ref
            .read(secureStorageProvider)
            .write(key: SecureStorageKey.token, value: res['token']);
        await ref
            .read(prefsProvider)
            .setString(PrefsKey.endpoint, ref.read(dockgeClientProvider).endpoint!);
        if (!ref.mounted) return;
        state = state.copyWith(username: username, loginStatus: .authenticated);
      },
    );
  }

  Future<void> loginWithToken() async {
    state = state.copyWith(loginStatus: .loading);
    final token = await ref.read(secureStorageProvider).read(key: SecureStorageKey.token);
    if (token == null) {
      state = state.copyWith(loginStatus: .unauthenticated);
      return;
    }

    final String username;
    try {
      username = JwtDecoder.decode(token)['username'];
    } catch (_) {
      await ref.read(secureStorageProvider).delete(key: SecureStorageKey.token);
      state = state.copyWith(loginStatus: .unauthenticated);
      return;
    }

    await _authenticate(
      event: "loginByToken",
      data: token,
      onSuccess: (_) {
        if (!ref.mounted) return;
        state = state.copyWith(username: username, loginStatus: .authenticated);
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(loginStatus: .unauthenticated, username: null);
    await ref.read(secureStorageProvider).delete(key: SecureStorageKey.token);
    ref.read(dockgeClientProvider).socket?.emit("logout");
  }

  Future<void> _authenticate({
    required String event,
    required dynamic data,
    required FutureOr<void> Function(Map res) onSuccess,
  }) async {
    final connected = await ref.read(dockgeClientProvider.notifier).waitForConnect();
    final socket = connected ? ref.read(dockgeClientProvider).socket : null;
    if (socket == null) {
      state = state.copyWith(loginStatus: .unauthenticated);
      ref.read(toastProvider.notifier).showError(message: "Connection error");
      return;
    }

    final completer = Completer<void>();
    socket.emitWithAck(
      event,
      data,
      ack: (dynamic err, [dynamic res]) async {
        if (completer.isCompleted) return;
        try {
          if (err != null) {
            if (!ref.mounted) return;
            state = state.copyWith(loginStatus: .unauthenticated);
            ref.read(toastProvider.notifier).showError(message: "Time out");
          } else if (res is Map && res["ok"] == true) {
            await onSuccess(res);
          } else {
            final msg = res is Map ? res["msg"]?.toString() : res?.toString();
            if (!ref.mounted) return;
            state = state.copyWith(loginStatus: .unauthenticated);
            ref.read(toastProvider.notifier).showError(message: msg ?? "Login failed");
          }
        } finally {
          if (!completer.isCompleted) completer.complete();
        }
      },
    );

    await completer.future;
  }
}
