import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';

class DockerPortMapping {
  const DockerPortMapping({
    required this.containerPort,
    this.hostIp,
    this.hostPort,
    this.protocol = 'tcp',
  });

  final String? hostIp;
  final String? hostPort;
  final String containerPort;
  final String protocol;

  @override
  String toString() {
    final result = StringBuffer();
    if (hostIp != null || hostPort != null) {
      if (hostIp case final ip?) {
        result
          ..write(ip.contains(':') ? '[$ip]' : ip)
          ..write(':');
      }
      if (hostPort case final port?) result.write(port);
      result.write(':');
    }
    result.write(containerPort);
    if (protocol != 'tcp') result.write('/$protocol');
    return result.toString();
  }
}

class StackService {
  StackService({
    required this.name,
    required this.status,
    required List<DockerPortMapping> ports,
    this.imageName,
  }) : ports = List.unmodifiable(ports);

  final String name;
  final String? imageName;
  final String status;
  final List<DockerPortMapping> ports;
}

class StackDetails {
  StackDetails({
    required this.name,
    required List<StackService> services,
    required this.composeFileName,
    required this.composeYaml,
    required this.composeEnv,
    this.summary,
  }) : services = List.unmodifiable(services);

  final String name;
  final StackSummary? summary;
  final List<StackService> services;
  final String composeFileName;
  final String composeYaml;
  final String composeEnv;

  StackDetails copyWith({StackSummary? summary}) => StackDetails(
    name: name,
    summary: summary,
    services: services,
    composeFileName: composeFileName,
    composeYaml: composeYaml,
    composeEnv: composeEnv,
  );
}
