import 'dart:async';

import 'package:dockge_dashboard/core/extensions/socket_io_ext.dart';
import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/data/models/dockge_dtos.dart';
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

  Future<AuthResultDto> login({
    required String username,
    required String password,
  }) async => AuthResultDto.fromResponse(
    await _emit('login', <String, Object?>{
      'username': username,
      'password': password,
    }),
  );

  Future<AuthResultDto> loginWithToken(String token) async =>
      AuthResultDto.fromResponse(await _emit('loginByToken', token));

  void logout() => _socket?.emit('logout');

  Future<StackDocumentDto> fetchStackDocument(String stackName) async =>
      StackDocumentDto.fromResponse(
        await _emitAgent('getStack', <Object?>[stackName]),
      );

  Future<ServiceStatusesDto> fetchServiceStatuses(String stackName) async =>
      ServiceStatusesDto.fromResponse(
        await _emitAgent('serviceStatusList', <Object?>[stackName]),
      );

  Future<ComposerizeResultDto> composerize(String command) async =>
      ComposerizeResultDto.fromResponse(await _emit('composerize', command));

  Future<OperationResultDto> runStackAction({
    required String event,
    required String stackName,
    required List<Object?> options,
    required Duration timeout,
  }) async => OperationResultDto.fromResponse(
    await _emitAgent(event, <Object?>[stackName, ...options], timeout: timeout),
  );

  Future<TerminalJoinResultDto> joinTerminal(String terminalName) async =>
      TerminalJoinResultDto.fromResponse(
        await _emitAgent('terminalJoin', <Object?>[terminalName]),
      );

  void leaveCombinedTerminal(String stackName) {
    final socket = _socket;
    if (socket == null || !socket.connected) return;
    socket.emitAgent('', 'leaveCombinedTerminal', <Object?>[stackName]);
  }

  void resizeTerminal({
    required String terminalName,
    required int rows,
    required int columns,
  }) {
    final socket = _socket;
    if (socket == null || !socket.connected) return;
    socket.emitAgent('', 'terminalResize', <Object?>[
      terminalName,
      rows,
      columns,
    ]);
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

  Future<Object?> _emitAgent(
    String event,
    List<Object?> arguments, {
    Duration timeout = const Duration(seconds: 15),
  }) => _connectedSocket.emitAgentAsync('', event, arguments, timeout: timeout);

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
