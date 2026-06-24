import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dockge_dashboard/core/providers/error_notifier.dart';
import 'package:dockge_dashboard/core/storage/prefs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

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
class DockgeClient extends _$DockgeClient {
  @override
  DockgeClientState build() {
    String? endpoint = ref.read(prefsProvider).getString(PrefsKey.endpoint);
    if (endpoint != null) {
      Future(() => connect(endpoint: endpoint));
    }
    return DockgeClientState(endpoint: null, status: .disconnected);
  }

  Completer<bool> _connected = Completer<bool>();

  Future<bool> waitForConnect() async {
    return _connected.future;
  }

  void connect({required String endpoint}) {
    if (state.status != .disconnected) {
      if (state.endpoint != endpoint) {
        disconnect();
      } else {
        return;
      }
    }
    state = state.copyWith(endpoint: endpoint, status: .connecting);
    final socket = io.io(
      endpoint,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .build(),
    );
    state = state.copyWith(socket: socket);

    socket.onConnect((_) {
      state = state.copyWith(status: .connected);
      if (!_connected.isCompleted) {
        _connected.complete(true);
      }
    });

    socket.onConnectError((error) {
      state = state.copyWith(status: .disconnected);
      ref.read(errorProvider.notifier).show(error.toString());
      if (!_connected.isCompleted) {
        _connected.complete(false);
        _connected = Completer<bool>();
      }
    });

    socket.onDisconnect((_) {
      state = state.copyWith(status: .disconnected);
      _connected = Completer<bool>();
    });

    socket.onError((error) {
      final currentSocket = state.socket;
      state = state.copyWith(status: .disconnected, socket: null);
      currentSocket?.dispose();
      ref.read(errorProvider.notifier).show(error.toString());
    });

    socket.onAny(((event, data) => log(jsonEncode(data), name: event)));
  }

  void disconnect() {
    if (state.socket == null) return;
    final currentSocket = state.socket;
    state = state.copyWith(socket: null, status: .disconnected);
    currentSocket?.disconnect();
    currentSocket?.dispose();
  }
}
