import 'package:dockge_dashboard/features/dashboard/models/network_topology.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_network_snapshot.dart';
import 'package:dockge_dashboard/features/dashboard/services/calculate_overview_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calculateOverviewMetrics', () {
    test('counts stack states and managed services', () {
      final catalog = StackCatalog(
        isSuccessful: true,
        stacks: [
          _stack('active', StackStatus.active, managed: true),
          _stack('exited', StackStatus.exited, managed: true),
          _stack('inactive', StackStatus.inactive, managed: false),
          _stack('unknown', StackStatus.unknown, managed: false),
          _stack('deploying', StackStatus.deploying, managed: true),
        ],
      );
      final topology = NetworkTopology(
        ports: const [],
        externalNetworks: const [],
        serviceCount: 7,
      );

      final metrics = calculateOverviewMetrics(catalog, topology);

      expect(metrics.stacks, 5);
      expect(metrics.active, 1);
      expect(metrics.exited, 1);
      expect(metrics.inactive, 1);
      expect(metrics.services, 7);
    });

    test('counts each published host port once and ignores dynamic ports', () {
      final topology = NetworkTopology(
        ports: const [
          PublishedPort(port: 53, stackName: 'dns', serviceName: 'dns-tcp'),
          PublishedPort(port: 53, stackName: 'dns', serviceName: 'dns-udp'),
          PublishedPort(port: 443, stackName: 'proxy', serviceName: 'https'),
          PublishedPort(stackName: 'app', serviceName: 'dynamic'),
        ],
        externalNetworks: const [],
        serviceCount: 4,
      );

      final metrics = calculateOverviewMetrics(null, topology);

      expect(metrics.ports, 2);
    });
  });
}

StackSummary _stack(String name, StackStatus status, {required bool managed}) => StackSummary(
  name: name,
  status: status,
  isManagedByDockge: managed,
  composeFileName: 'compose.yaml',
);
