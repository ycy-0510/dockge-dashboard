import 'dart:async';
import 'dart:developer';

import 'package:dockge_dashboard/app/shared/toast/toast_notifier.dart';
import 'package:dockge_dashboard/app/core/storage/prefs.dart';
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

    final endpoint = ref.read(prefsStoreProvider).readEndpoint();
    if (endpoint != null) {
      Future(() => connect(endpoint: endpoint));
    }
    return DockgeClientState(endpoint: null, status: SocketStatus.disconnected);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final socket = this.state.socket;
      if (socket != null && this.state.endpoint != null && !socket.connected) {
        log("App resumed, socket disconnected, reconnecting...");
        socket.connect();
      }
    }
  }

  Completer<bool> _connected = Completer<bool>();

  Future<bool> waitForConnect({
    Duration timeout = const Duration(seconds: 20),
  }) {
    if (state.status == SocketStatus.connected) return Future.value(true);
    return _connected.future.timeout(timeout, onTimeout: () => false);
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

    socket.onConnect((Object? _) {
      state = state.copyWith(status: SocketStatus.connected);
      if (!_connected.isCompleted) {
        _connected.complete(true);
      }
    });

    socket.onConnectError((Object? error) {
      state = state.copyWith(status: SocketStatus.disconnected);
      ref.read(toastProvider.notifier).showError(message: error.toString());
      if (!_connected.isCompleted) {
        _connected.complete(false);
        _connected = Completer<bool>();
      }
    });

    socket.onDisconnect((Object? _) {
      state = state.copyWith(status: .disconnected);
      _connected = Completer<bool>();
    });

    socket.onError((Object? error) {
      state = state.copyWith(status: .disconnected);
      ref.read(toastProvider.notifier).showError(message: error.toString());
    });

    socket.onAny((String event, Object? data) {
      // Skip high-frequency terminal streaming to avoid encoding overhead.
      if (event == 'agent' &&
          data is List<Object?> &&
          data.isNotEmpty &&
          data.first == 'terminalWrite') {
        return;
      }
      log(data.toString(), name: event);
    });
  }

  void disconnect() {
    if (state.socket == null) return;
    final currentSocket = state.socket;
    state = state.copyWith(socket: null, status: .disconnected);
    _connected = Completer<bool>();
    currentSocket?.disconnect();
    currentSocket?.dispose();
  }
}
