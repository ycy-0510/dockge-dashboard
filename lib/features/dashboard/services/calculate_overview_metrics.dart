import 'package:dockge_dashboard/features/dashboard/models/network_topology.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';

OverviewMetrics calculateOverviewMetrics(
  StackCatalog? catalog,
  NetworkTopology topology,
) {
  final stacks = catalog?.stacks ?? const <StackSummary>[];
  final usedPorts = topology.ports.map((mapping) => mapping.port).whereType<int>().toSet();

  return OverviewMetrics(
    stacks: stacks.length,
    active: stacks.where((stack) => stack.status == .active).length,
    exited: stacks.where((stack) => stack.status == .exited).length,
    inactive: stacks.where((stack) => stack.status == .inactive).length,
    services: topology.serviceCount,
    ports: usedPorts.length,
  );
}
