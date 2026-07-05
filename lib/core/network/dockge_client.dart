import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dockge_dashboard/core/providers/toast_notifier.dart';
import 'package:dockge_dashboard/core/storage/prefs.dart';
import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:flutter/widgets.dart';

part 'dockge_client.g.dart';
part 'dockge_client.freezed.dart';

enum SocketStatus { disconnected, connecting, connected }

@freezed
abstract class DockgeClientState with _$DockgeClientState {
  const factory DockgeClientState({
    io.Socket? socket,
    required String? endpoint,
    required SocketStatus status,
  }) = _DockgeClientState;
}

@Riverpod(keepAlive: true)
class DockgeClient extends _$DockgeClient with WidgetsBindingObserver {
  @override
  DockgeClientState build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
    });

    String? endpoint = ref.read(prefsProvider).getString(PrefsKey.endpoint);
    if (endpoint != null) {
      Future(() => connect(endpoint: endpoint));
    }
    return DockgeClientState(endpoint: null, status: SocketStatus.disconnected);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (this.state.socket != null && this.state.endpoint != null) {
        log("App resumed, forcing socket reconnect...");
        final socket = this.state.socket!;
        socket.disconnect();
        socket.connect();
      }
    }
  }

  Completer<bool> _connected = Completer<bool>();

  Future<bool> waitForConnect() async {
    return _connected.future;
  }

  void connect({required String endpoint}) {
    if (state.socket != null && state.endpoint == endpoint) {
      if (state.status == SocketStatus.disconnected) {
        state = state.copyWith(status: SocketStatus.connecting);
        state.socket!.connect();
      }
      return;
    }

    disconnect();
    state = state.copyWith(endpoint: endpoint, status: SocketStatus.connecting);
    final socket = io.io(
      endpoint,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setAckTimeout(15000)
          .build(),
    );
    state = state.copyWith(socket: socket);

    socket.onConnect((_) {
      state = state.copyWith(status: SocketStatus.connected);
      if (!_connected.isCompleted) {
        _connected.complete(true);
      }
      final loginStatus = ref.read(authControllerProvider).loginStatus;
      if (loginStatus == LoginStatus.loading || loginStatus == LoginStatus.authenticated) {
        ref.read(authControllerProvider.notifier).loginWithToken();
      }
    });

    socket.onConnectError((error) {
      state = state.copyWith(status: SocketStatus.disconnected);
      ref.read(toastProvider.notifier).showError(message: error.toString());
      if (!_connected.isCompleted) {
        _connected.complete(false);
        _connected = Completer<bool>();
      }
      if (ref.read(authControllerProvider).loginStatus == LoginStatus.loading) {
        ref.read(authControllerProvider.notifier).setUnauthenticated();
      }
    });

    socket.onDisconnect((_) {
      state = state.copyWith(status: .disconnected);
      _connected = Completer<bool>();
    });

    socket.onError((error) {
      state = state.copyWith(status: .disconnected);
      ref.read(toastProvider.notifier).showError(message: error.toString());
      if (ref.read(authControllerProvider).loginStatus == LoginStatus.loading) {
        ref.read(authControllerProvider.notifier).setUnauthenticated();
      }
    });

    socket.onAny((event, data) {
      // Skip high-frequency terminal streaming to avoid encoding overhead.
      if (event == 'agent' && data is List && data.isNotEmpty && data[0] == 'terminalWrite') {
        return;
      }
      log(jsonEncode(data), name: event);
    });
  }

  void disconnect() {
    if (state.socket == null) return;
    final currentSocket = state.socket;
    state = state.copyWith(socket: null, status: .disconnected);
    currentSocket?.disconnect();
    currentSocket?.dispose();
  }
}
