import 'package:dockge_dashboard/data/models/dockge_dtos.dart';
import 'package:dockge_dashboard/data/models/wire_value.dart';
import 'package:dockge_dashboard/domain/models/network_topology.dart';
import 'package:dockge_dashboard/domain/models/stack_details.dart';
import 'package:dockge_dashboard/domain/use_cases/docker_port_parser.dart';
import 'package:yaml/yaml.dart';

abstract final class ComposeDocumentParser {
  static List<StackService> parseServices(
    String composeYaml,
    ServiceStatusesDto statuses,
  ) {
    final services = _services(composeYaml);
    return [
      for (final entry in services.entries)
        if (entry.key is String && entry.value is YamlMap)
          _parseService(entry.key as String, entry.value as YamlMap, statuses),
    ];
  }

  static StackNetworkSnapshot parseNetwork({
    required String stackName,
    required String composeYaml,
  }) {
    final document = _document(composeYaml);
    final Object? servicesValue = document['services'];
    if (servicesValue is! YamlMap) {
      return StackNetworkSnapshot(
        ports: const [],
        externalNetworkNames: const [],
        hostNetworkServices: const [],
        serviceCount: 0,
      );
    }

    final aliases = _externalNetworkAliases(document['networks']);
    final ports = <PublishedPort>[];
    final externalNetworks = <String>{};
    final hostServices = <String>[];
    var serviceCount = 0;

    for (final entry in servicesValue.entries) {
      if (entry.key is! String || entry.value is! YamlMap) continue;
      final serviceName = entry.key as String;
      final service = entry.value as YamlMap;
      serviceCount++;

      final Object? rawPorts = service['ports'];
      if (rawPorts is YamlList) {
        for (final rawPort in rawPorts.nodes.map((node) => node.value)) {
          final port = _parsePort(rawPort);
          if (port == null) continue;
          ports.add(
            PublishedPort(
              port: int.tryParse(port.hostPort ?? ''),
              stackName: stackName,
              serviceName: serviceName,
            ),
          );
        }
      }

      if (service['network_mode'] == 'host') hostServices.add(serviceName);
      for (final alias in _serviceNetworkAliases(service)) {
        final externalName = aliases[alias];
        if (externalName != null) externalNetworks.add(externalName);
      }
    }

    return StackNetworkSnapshot(
      ports: ports,
      externalNetworkNames: externalNetworks.toList(),
      hostNetworkServices: hostServices,
      serviceCount: serviceCount,
    );
  }

  static YamlMap _document(String composeYaml) {
    final Object? document = loadYaml(composeYaml);
    if (document is YamlMap) return document;
    throw const WireFormatException('Compose document must be a YAML object');
  }

  static YamlMap _services(String composeYaml) {
    final Object? services = _document(composeYaml)['services'];
    if (services is YamlMap) return services;
    throw const WireFormatException('Compose document must contain services');
  }

  static StackService _parseService(
    String name,
    YamlMap service,
    ServiceStatusesDto statuses,
  ) {
    final ports = <DockerPortMapping>[];
    final Object? rawPorts = service['ports'];
    if (rawPorts is YamlList) {
      for (final node in rawPorts.nodes) {
        final mapping = _parsePort(node.value);
        if (mapping != null) ports.add(mapping);
      }
    }
    return StackService(
      name: name,
      imageName: switch (service['image']) {
        final String image => image,
        _ => null,
      },
      status: statuses.statusFor(name),
      ports: ports,
    );
  }

  static DockerPortMapping? _parsePort(Object? rawPort) => switch (rawPort) {
    final String value => DockerPortParser.parse(value),
    final num value => DockerPortParser.parse(value.toString()),
    final YamlMap value => _parseLongPort(value),
    _ => null,
  };

  static DockerPortMapping? _parseLongPort(YamlMap value) {
    final target = value['target']?.toString();
    if (target == null || target.isEmpty) return null;
    return DockerPortMapping(
      hostIp: value['host_ip']?.toString(),
      hostPort: value['published']?.toString(),
      containerPort: target,
      protocol: value['protocol']?.toString() ?? 'tcp',
    );
  }

  static Map<String, String> _externalNetworkAliases(Object? rawNetworks) {
    if (rawNetworks is! YamlMap) return const {};
    final result = <String, String>{};
    for (final entry in rawNetworks.entries) {
      if (entry.key is! String || entry.value is! YamlMap) continue;
      final alias = entry.key as String;
      final config = entry.value as YamlMap;
      final Object? external = config['external'];
      final explicitName = config['name']?.toString();
      final legacyName = external is YamlMap ? external['name']?.toString() : null;
      if (external != true && external is! YamlMap && explicitName == null) {
        continue;
      }
      result[alias] = switch (explicitName ?? legacyName) {
        final name? when name.isNotEmpty => name,
        _ => alias,
      };
    }
    return result;
  }

  static List<String> _serviceNetworkAliases(YamlMap service) {
    final Object? rawNetworks = service['networks'];
    if (rawNetworks is YamlMap) {
      return rawNetworks.keys.whereType<String>().toList();
    }
    if (rawNetworks is YamlList) {
      return rawNetworks.nodes.map((node) => node.value.toString()).toList();
    }
    return service['network_mode'] == null ? const ['default'] : const [];
  }
}
