import 'dart:async';

import 'package:dockge_dashboard/app/core/extensions/socket_io_ext.dart';
import 'package:dockge_dashboard/app/core/network/dockge_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'dockge_api_service.g.dart';

class DockgeConnectionException implements Exception {
  const DockgeConnectionException(this.message);

  final String message;

  @override
  String toString() => 'DockgeConnectionException: $message';
}

final class DockgeApiService {
  DockgeApiService(io.Socket? socket) : _socket = socket {
    _socket?.on('agent', _handleAgentEvent);
  }

  final io.Socket? _socket;
  final StreamController<Object?> _agentEvents = StreamController<Object?>.broadcast(sync: true);

  Stream<Object?> get agentEvents => _agentEvents.stream;

  bool get isConnected => _socket?.connected ?? false;

  Future<Object?> request(
    String event,
    Object? payload, {
    Duration timeout = const Duration(seconds: 15),
  }) => _emit(event, payload, timeout: timeout);

  Future<Object?> requestAgent(
    String event,
    List<Object?> arguments, {
    Duration timeout = const Duration(seconds: 15),
  }) => _connectedSocket.emitAgentAsync(
    '',
    event,
    arguments,
    timeout: timeout,
  );

  void send(String event, [Object? payload]) {
    final socket = _socket;
    if (socket == null) return;
    if (payload == null) {
      socket.emit(event);
    } else {
      socket.emit(event, payload);
    }
  }

  void sendAgent(String event, List<Object?> arguments) {
    final socket = _socket;
    if (socket == null || !socket.connected) return;
    socket.emitAgent('', event, arguments);
  }

  void dispose() {
    _socket?.off('agent', _handleAgentEvent);
    unawaited(_agentEvents.close());
  }

  void _handleAgentEvent(Object? event) => _agentEvents.add(event);

  io.Socket get _connectedSocket {
    final socket = _socket;
    if (socket == null || !socket.connected) {
      throw const DockgeConnectionException('Not connected to server');
    }
    return socket;
  }

  Future<Object?> _emit(
    String event,
    Object? payload, {
    Duration timeout = const Duration(seconds: 15),
  }) {
    final completer = Completer<Object?>();
    _connectedSocket
        .timeout(timeout.inMilliseconds)
        .emitWithAck(
          event,
          payload,
          ack: (Object? error, [Object? response]) {
            if (completer.isCompleted) return;
            if (error != null) {
              completer.completeError(error);
            } else {
              completer.complete(response);
            }
          },
        );
    return completer.future;
  }
}

@riverpod
DockgeApiService dockgeApiService(Ref ref) {
  final socket = ref.watch(dockgeClientProvider).socket;
  final service = DockgeApiService(socket);
  ref.onDispose(service.dispose);
  return service;
}
