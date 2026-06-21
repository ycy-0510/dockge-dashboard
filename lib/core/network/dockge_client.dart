import 'dart:async';

import 'package:dockge_dashboard/core/storage/prefs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'dockge_client.g.dart';
part 'dockge_client.freezed.dart';

enum SocketStatus { disconnected, connecting, connected }

@freezed
abstract class DockgeClientState with _$DockgeClientState {
  const DockgeClientState._();

  const factory DockgeClientState({
    io.Socket? socket,
    String? error,
    required String? endpoint,
    required SocketStatus status,
  }) = _DockgeClientState;

  bool get hasError => error != null;
}

@Riverpod(keepAlive: true)
class DockgeClient extends _$DockgeClient {
  @override
  DockgeClientState build() {
    String? endpoint = ref.read(prefsProvider).getString(PrefsKey.endpoint);
    if (endpoint != null) {
      Future(() => connect(endpoint: endpoint));
    }
    return DockgeClientState(endpoint: null, status: .disconnected, error: null);
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
    state = state.copyWith(endpoint: endpoint, status: .connecting, error: null);
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
      state = state.copyWith(status: .connected, error: null);
      if (!_connected.isCompleted) {
        _connected.complete(true);
      }
    });

    socket.onConnectError((error) {
      state = state.copyWith(status: .disconnected, error: error.toString());
      if (!_connected.isCompleted) {
        _connected.complete(false);
        _connected = Completer<bool>();
      }
    });

    socket.onDisconnect((_) {
      state = state.copyWith(status: .disconnected, error: null);
      _connected = Completer<bool>();
    });

    socket.onError((error) {
      state = state.copyWith(error: error.toString());
      state.socket?.dispose();
      state = state.copyWith(socket: null, endpoint: null);
    });

    socket.onAny(((event, data) => print("$event $data")));
  }

  void disconnect() {
    if (state.status != .connected) return;
    state.socket?.disconnect();
    state.socket?.dispose();
    state = state.copyWith(socket: null);
  }
}
