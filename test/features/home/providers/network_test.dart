import 'package:dockge_dashboard/features/home/model/network_state.dart';
import 'package:dockge_dashboard/features/home/model/stack_info.dart';
import 'package:dockge_dashboard/features/home/model/status.dart';
import 'package:dockge_dashboard/features/home/providers/network.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calculateOverviewMetrics', () {
    test('counts every stack status but only the loaded managed services', () {
      final stacks = StackInfo(
        ok: true,
        stackList: {
          'active': _stack('active', StackStatus.active, managed: true),
          'exited': _stack('exited', StackStatus.exited, managed: true),
          'inactive': _stack('inactive', StackStatus.inactive, managed: false),
          'unknown': _stack('unknown', StackStatus.unknown, managed: false),
          'deploying': _stack(
            'deploying',
            StackStatus.deploying,
            managed: true,
          ),
        },
      );
      const network = NetworkState(
        ports: [],
        globalNetworks: [],
        serviceCount: 7,
      );

      final metrics = calculateOverviewMetrics(stacks, network);

      expect(metrics.stacks, 5);
      expect(metrics.active, 1);
      expect(metrics.exited, 1);
      expect(metrics.inactive, 1);
      expect(metrics.services, 7);
    });

    test('counts each published host port once and ignores dynamic ports', () {
      const network = NetworkState(
        ports: [
          PortState(port: 53, stackName: 'dns', serviceName: 'dns-tcp'),
          PortState(port: 53, stackName: 'dns', serviceName: 'dns-udp'),
          PortState(port: 443, stackName: 'proxy', serviceName: 'https'),
          PortState(stackName: 'app', serviceName: 'dynamic'),
        ],
        globalNetworks: [],
        serviceCount: 4,
      );

      final metrics = calculateOverviewMetrics(null, network);

      expect(metrics.ports, 2);
    });
  });
}

StackItem _stack(String name, StackStatus status, {required bool managed}) =>
    StackItem(
      name: name,
      status: status,
      isManagedByDockge: managed,
      composeFileName: 'compose.yaml',
    );
