import 'package:dockge_dashboard/features/stacks/models/stack_network_snapshot.dart';

class ExternalNetwork {
  ExternalNetwork({required this.name, required List<String> members})
    : members = List.unmodifiable(members);

  final String name;
  final List<String> members;

  ExternalNetwork copyWith({List<String>? members}) =>
      ExternalNetwork(name: name, members: members ?? this.members);
}

class NetworkTopology {
  NetworkTopology({
    required List<PublishedPort> ports,
    required List<ExternalNetwork> externalNetworks,
    required this.serviceCount,
  }) : ports = List.unmodifiable(ports),
       externalNetworks = List.unmodifiable(externalNetworks);

  const NetworkTopology.empty() : ports = const [], externalNetworks = const [], serviceCount = 0;

  final List<PublishedPort> ports;
  final List<ExternalNetwork> externalNetworks;
  final int serviceCount;
}

class OverviewMetrics {
  const OverviewMetrics({
    required this.stacks,
    required this.active,
    required this.exited,
    required this.inactive,
    required this.services,
    required this.ports,
  });

  final int stacks;
  final int active;
  final int exited;
  final int inactive;
  final int services;
  final int ports;
}
