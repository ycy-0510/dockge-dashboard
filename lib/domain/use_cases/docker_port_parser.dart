import 'package:dockge_dashboard/domain/models/stack_details.dart';

abstract final class DockerPortParser {
  static DockerPortMapping parse(String rawValue) {
    var value = rawValue.trim();
    var protocol = 'tcp';
    final slash = value.lastIndexOf('/');
    if (slash != -1) {
      protocol = value.substring(slash + 1);
      value = value.substring(0, slash);
    }

    final parts = value.split(':');
    final containerPort = parts.last;
    String? hostIp;
    String? hostPort;
    switch (parts.length) {
      case 1:
        break;
      case 2:
        hostPort = parts.first;
      case 3:
        hostIp = parts.first;
        hostPort = parts[1];
      default:
        hostIp = parts.sublist(0, parts.length - 2).join(':');
        hostPort = parts[parts.length - 2];
    }

    if (hostIp != null && hostIp.startsWith('[') && hostIp.endsWith(']')) {
      hostIp = hostIp.substring(1, hostIp.length - 1);
    }

    return DockerPortMapping(
      hostIp: switch (hostIp) {
        final value? when value.isNotEmpty => value,
        _ => null,
      },
      hostPort: switch (hostPort) {
        final value? when value.isNotEmpty => value,
        _ => null,
      },
      containerPort: containerPort,
      protocol: protocol,
    );
  }
}
