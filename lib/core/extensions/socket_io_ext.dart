import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;

extension SocketIoExt on io.Socket {
  void emitAgent(String endpoint, String event, List args, {Function? ack}) {
    emitWithAck('agent', [endpoint, event, ...args], ack: ack);
  }

  Future<dynamic> emitAgentAsync(String endpoint, String event, List args) {
    final completer = Completer<dynamic>();
    emitWithAck(
      'agent',
      [endpoint, event, ...args],
      ack: (dynamic err, [dynamic response]) {
        if (!completer.isCompleted) {
          if (err != null) {
            completer.completeError(err);
          } else {
            completer.complete(response);
          }
        }
      },
    );
    return completer.future;
  }
}
