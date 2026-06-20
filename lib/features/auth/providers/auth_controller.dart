import 'dart:async';

import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/core/storage/prefs.dart';
import 'package:dockge_dashboard/core/storage/secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.freezed.dart';
part 'auth_controller.g.dart';

enum LoginStatus { loading, authenticated, unauthenticated }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({required LoginStatus loginStatus, String? username, String? error}) =
      _AuthState;
}

@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    return AuthState(loginStatus: .unauthenticated);
  }

  Future<void> login({required String username, required String password}) async {
    state = state.copyWith(loginStatus: .loading, error: null);
    final connected = await ref.read(dockgeClientProvider.notifier).waitForConnect();
    if (!connected) {
      state = state.copyWith(loginStatus: .unauthenticated, error: null);
      return;
    }
    final socket = ref.read(dockgeClientProvider).socket;
    if (socket == null) {
      state = state.copyWith(loginStatus: .unauthenticated, error: null);
      return;
    }
    Completer<void> completer = Completer();
    socket.emitWithAck(
      "login",
      {"username": username, "password": password},
      ack: (res) {
        if (res is Map && res["ok"] == true) {
          ref.read(secureStorageProvider).write(key: SecureStorageKey.token, value: res['token']);
          ref
              .read(prefsProvider)
              .setString(PrefsKey.endpoint, ref.read(dockgeClientProvider).endpoint!);
          state = state.copyWith(username: username, loginStatus: .authenticated, error: null);
        } else {
          final msg = res is Map ? res["msg"]?.toString() : res?.toString();
          state = state.copyWith(loginStatus: .unauthenticated, error: msg ?? "Login failed");
        }
        completer.complete();
      },
    );
    await completer.future;
  }

  Future<void> loginWithToken() async {
    state = state.copyWith(loginStatus: .loading, error: null);
    final connected = await ref.read(dockgeClientProvider.notifier).waitForConnect();
    if (!connected) {
      state = state.copyWith(loginStatus: .unauthenticated, error: null);
      return;
    }
    final socket = ref.read(dockgeClientProvider).socket;
    if (socket == null) {
      state = state.copyWith(loginStatus: .unauthenticated, error: null);
      return;
    }
    final token = await ref.read(secureStorageProvider).read(key: SecureStorageKey.token);
    if (token == null) {
      state = state.copyWith(loginStatus: .unauthenticated, error: null);
      return;
    }
    final username = JwtDecoder.decode(token)['username'];
    Completer<void> completer = Completer();
    socket.emitWithAck(
      "loginByToken",
      token,
      ack: (res) {
        if (res is Map && res["ok"] == true) {
          state = state.copyWith(username: username, loginStatus: .authenticated, error: null);
        } else {
          final msg = res is Map ? res["msg"]?.toString() : res?.toString();
          state = state.copyWith(loginStatus: .unauthenticated, error: msg ?? "Login failed");
        }
        completer.complete();
      },
    );
    await completer.future;
  }

  void logout() {
    state = state.copyWith(loginStatus: .unauthenticated, username: null, error: null);
    final socket = ref.read(dockgeClientProvider).socket;
    if (socket == null) return;
    socket.emit("logout");
  }
}
