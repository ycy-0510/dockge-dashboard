import 'package:dockge_dashboard/features/home/model/stack_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xterm/xterm.dart';

part 'stack_detail_info.freezed.dart';

@freezed
abstract class StackDetailInfo with _$StackDetailInfo {
  const factory StackDetailInfo({
    required String name,
    required StackItem? info,
    required List<ServiceInfo> services,
  }) = _StackDetailInfo;
}

@freezed
abstract class ServiceInfo with _$ServiceInfo {
  const factory ServiceInfo({
    required String name,
    required String imageName,
    required String status,
    required List<PortMapping> ports,
  }) = _ServiceInfo;
}

/// Docker Compose short-syntax port:`[HOST:]CONTAINER[/PROTOCOL]`
class PortMapping {
  final String? hostIp; // null = All(0.0.0.0)
  final String? hostPort; // null = runtime random
  final String containerPort;
  final String protocol; // tcp / udp

  const PortMapping({
    this.hostIp,
    this.hostPort,
    required this.containerPort,
    this.protocol = 'tcp',
  });

  @override
  String toString() {
    final b = StringBuffer();
    if (hostIp != null || hostPort != null) {
      if (hostIp != null) {
        b.write(hostIp!.contains(':') ? '[$hostIp]' : hostIp);
        b.write(':');
      }
      if (hostPort != null) b.write(hostPort);
      b.write(':');
    }
    b.write(containerPort);
    if (protocol != 'tcp') b.write('/$protocol');
    return b.toString();
  }

  static PortMapping parsePortSpec(String raw) {
    var s = raw.trim();

    var protocol = 'tcp';
    final slash = s.lastIndexOf('/');
    if (slash != -1) {
      protocol = s.substring(slash + 1);
      s = s.substring(0, slash);
    }

    final parts = s.split(':');
    final n = parts.length;
    final container = parts[n - 1];
    String? ip, host;
    switch (n) {
      case 1:
        break;
      case 2:
        host = parts[0];
        break;
      case 3:
        ip = parts[0];
        host = parts[1];
        break;
      default:
        ip = parts.sublist(0, n - 2).join(':');
        host = parts[n - 2];
    }

    if (ip != null && ip.startsWith('[') && ip.endsWith(']')) {
      ip = ip.substring(1, ip.length - 1);
    }

    return PortMapping(
      hostIp: (ip == null || ip.isEmpty) ? null : ip,
      hostPort: (host == null || host.isEmpty) ? null : host,
      containerPort: container,
      protocol: protocol,
    );
  }
}

@freezed
abstract class StackTerminalState with _$StackTerminalState {
  const factory StackTerminalState({
    required String name,
    required Terminal combinedTerminal,
    Terminal? composeTerminal,
  }) = _StackTerminalState;
}
