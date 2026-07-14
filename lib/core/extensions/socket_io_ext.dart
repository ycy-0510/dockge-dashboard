import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;

extension SocketIoExt on io.Socket {
  void emitAgent(
    String endpoint,
    String event,
    List<Object?> args, {
    void Function(Object?)? ack,
  }) {
    emitWithAck('agent', [endpoint, event, ...args], ack: ack);
  }

  Future<Object?> emitAgentAsync(
    String endpoint,
    String event,
    List<Object?> args, {
    Duration timeout = const Duration(seconds: 15),
  }) {
    final completer = Completer<Object?>();
    // Setting a per-call timeout also makes socket_io_client wrap the ack with
    // the (err, response) convention. Without any timeout the ack is called as
    // (response) instead, which would put the payload into `err`.
    this
        .timeout(timeout.inMilliseconds)
        .emitWithAck(
          'agent',
          [endpoint, event, ...args],
          ack: (Object? err, [Object? response]) {
            if (completer.isCompleted) return;
            if (err != null) {
              completer.completeError(err);
            } else {
              completer.complete(response);
            }
          },
        );
    return completer.future;
  }
}
