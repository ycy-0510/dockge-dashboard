import 'dart:developer';

import 'package:dockge_dashboard/features/dashboard/models/network_topology.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_network_snapshot.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:dockge_dashboard/features/stacks/services/dockge_stack_repository.dart';
import 'package:dockge_dashboard/features/stacks/services/stack_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_topology_service.g.dart';

final class NetworkTopologyLoadResult {
  const NetworkTopologyLoadResult({
    required this.topology,
    required this.failedStackCount,
  });

  final NetworkTopology topology;
  final int failedStackCount;
}

/// Loads and combines network data without exposing data-access work to the view.
final class NetworkTopologyService {
  const NetworkTopologyService(this._stackRepository);

  final StackRepository _stackRepository;

  Future<NetworkTopologyLoadResult> load(StackCatalog catalog) async {
    final stackNames = catalog.stacks
        .where((stack) => stack.isManagedByDockge)
        .map((stack) => stack.name)
        .toList(growable: false);
    if (stackNames.isEmpty) {
      return const NetworkTopologyLoadResult(
        topology: NetworkTopology.empty(),
        failedStackCount: 0,
      );
    }

    final ports = <PublishedPort>[];
    final networkMembers = <String, Set<String>>{};
    var serviceCount = 0;
    var failedStacks = 0;

    for (final stackName in stackNames) {
      try {
        final snapshot = await _stackRepository.fetchNetwork(stackName);
        ports.addAll(snapshot.ports);
        serviceCount += snapshot.serviceCount;
        for (final networkName in snapshot.externalNetworkNames) {
          networkMembers.putIfAbsent(networkName, () => <String>{}).add(stackName);
        }
        for (final serviceName in snapshot.hostNetworkServices) {
          networkMembers.putIfAbsent('host', () => <String>{}).add('$stackName → $serviceName');
        }
      } catch (error, stackTrace) {
        failedStacks++;
        log(
          'Failed to load network data for $stackName',
          name: 'NetworkTopologyService',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    ports.sort((left, right) {
      final byPort = (left.port ?? 1 << 30).compareTo(right.port ?? 1 << 30);
      return byPort != 0 ? byPort : left.stackName.compareTo(right.stackName);
    });
    final externalNetworks = [
      for (final entry in networkMembers.entries)
        ExternalNetwork(name: entry.key, members: entry.value.toList()..sort()),
    ]..sort((left, right) => left.name.compareTo(right.name));

    return NetworkTopologyLoadResult(
      topology: NetworkTopology(
        ports: ports,
        externalNetworks: externalNetworks,
        serviceCount: serviceCount,
      ),
      failedStackCount: failedStacks,
    );
  }
}

@riverpod
NetworkTopologyService networkTopologyService(Ref ref) =>
    NetworkTopologyService(ref.watch(stackRepositoryProvider));
