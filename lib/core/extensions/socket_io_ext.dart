import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;

extension SocketIoExt on io.Socket {
  void emitAgent(String endpoint, String event, List args, {Function? ack}) {
    emitWithAck('agent', [endpoint, event, ...args], ack: ack);
  }

  Future<dynamic> emitAgentAsync(
    String endpoint,
    String event,
    List args, {
    Duration timeout = const Duration(seconds: 15),
  }) {
    final completer = Completer<dynamic>();
    // Setting a per-call timeout also makes socket_io_client wrap the ack with
    // the (err, response) convention. Without any timeout the ack is called as
    // (response) instead, which would put the payload into `err`.
    this.timeout(timeout.inMilliseconds).emitWithAck(
      'agent',
      [endpoint, event, ...args],
      ack: (dynamic err, [dynamic response]) {
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
