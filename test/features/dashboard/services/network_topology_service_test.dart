import 'package:dockge_dashboard/features/dashboard/services/network_topology_service.dart';
import 'package:dockge_dashboard/features/stacks/models/operation_result.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_details.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_network_snapshot.dart';
import 'package:dockge_dashboard/features/stacks/services/stack_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkTopologyService', () {
    test('combines, sorts, and reports partial network results', () async {
      final repository = _FakeStackRepository(
        snapshots: {
          'alpha': StackNetworkSnapshot(
            ports: const [
              PublishedPort(stackName: 'alpha', serviceName: 'web', port: 8080),
            ],
            externalNetworkNames: const ['proxy'],
            hostNetworkServices: const ['metrics'],
            serviceCount: 2,
          ),
          'beta': StackNetworkSnapshot(
            ports: const [
              PublishedPort(stackName: 'beta', serviceName: 'api', port: 3000),
            ],
            externalNetworkNames: const ['proxy'],
            hostNetworkServices: const [],
            serviceCount: 1,
          ),
        },
        failingStacks: const {'broken'},
      );
      final service = NetworkTopologyService(repository);

      final result = await service.load(
        StackCatalog(
          isSuccessful: true,
          stacks: const [
            StackSummary(
              name: 'alpha',
              status: StackStatus.active,
              isManagedByDockge: true,
              composeFileName: 'compose.yaml',
            ),
            StackSummary(
              name: 'unmanaged',
              status: StackStatus.active,
              isManagedByDockge: false,
              composeFileName: 'compose.yaml',
            ),
            StackSummary(
              name: 'broken',
              status: StackStatus.exited,
              isManagedByDockge: true,
              composeFileName: 'compose.yaml',
            ),
            StackSummary(
              name: 'beta',
              status: StackStatus.active,
              isManagedByDockge: true,
              composeFileName: 'compose.yaml',
            ),
          ],
        ),
      );

      expect(result.failedStackCount, 1);
      expect(result.topology.serviceCount, 3);
      expect(result.topology.ports.map((port) => port.port), [3000, 8080]);
      expect(
        result.topology.externalNetworks.map((network) => network.name),
        ['host', 'proxy'],
      );
      expect(result.topology.externalNetworks[0].members, ['alpha → metrics']);
      expect(result.topology.externalNetworks[1].members, ['alpha', 'beta']);
      expect(repository.requestedStacks, ['alpha', 'broken', 'beta']);
    });
  });
}

final class _FakeStackRepository implements StackRepository {
  _FakeStackRepository({
    required this.snapshots,
    this.failingStacks = const {},
  });

  final Map<String, StackNetworkSnapshot> snapshots;
  final Set<String> failingStacks;
  final List<String> requestedStacks = [];

  @override
  Future<StackNetworkSnapshot> fetchNetwork(String stackName) async {
    requestedStacks.add(stackName);
    if (failingStacks.contains(stackName)) throw StateError('failed');
    return snapshots[stackName]!;
  }

  @override
  Future<StackDetails> fetchDetails(String stackName) => throw UnimplementedError();

  @override
  Future<OperationResult> performAction({
    required StackAction action,
    required String stackName,
  }) => throw UnimplementedError();

  @override
  Future<OperationResult> saveStack({
    required String stackName,
    required String composeYaml,
    required String composeEnv,
    required bool isNew,
    required bool deploy,
  }) => throw UnimplementedError();

  @override
  Stream<StackCatalog> watchCatalog() => const Stream.empty();
}
