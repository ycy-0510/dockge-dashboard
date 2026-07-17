class PublishedPort {
  const PublishedPort({
    required this.stackName,
    required this.serviceName,
    this.port,
  });

  final int? port;
  final String stackName;
  final String serviceName;
}

class StackNetworkSnapshot {
  StackNetworkSnapshot({
    required List<PublishedPort> ports,
    required List<String> externalNetworkNames,
    required List<String> hostNetworkServices,
    required this.serviceCount,
  }) : ports = List.unmodifiable(ports),
       externalNetworkNames = List.unmodifiable(externalNetworkNames),
       hostNetworkServices = List.unmodifiable(hostNetworkServices);

  final List<PublishedPort> ports;
  final List<String> externalNetworkNames;
  final List<String> hostNetworkServices;
  final int serviceCount;
}
