import 'dart:developer';

import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:dockge_dashboard/core/providers/toast_notifier.dart';
import 'package:dockge_dashboard/core/extensions/socket_io_ext.dart';
import 'package:dockge_dashboard/features/auth/providers/auth_controller.dart';
import 'package:dockge_dashboard/features/home/model/network_state.dart';
import 'package:dockge_dashboard/features/home/model/stack_detail_info.dart';
import 'package:dockge_dashboard/features/home/model/stack_info.dart';
import 'package:dockge_dashboard/features/home/providers/stack_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaml/yaml.dart';

part 'network.g.dart';

@riverpod
class Network extends _$Network {
  int _fetchRevision = 0;

  @override
  NetworkState build() {
    ref.listen(stackListProvider, (prev, next) {
      if (next != null && next != prev) {
        _scheduleFetch(_managedStackNames(next));
      }
    });

    ref.listen(authControllerProvider, (prev, next) {
      if (next.loginStatus == LoginStatus.authenticated &&
          prev?.loginStatus != LoginStatus.authenticated) {
        final stacks = ref.read(stackListProvider);
        if (stacks != null) _scheduleFetch(_managedStackNames(stacks));
      }
    });

    final stackList = ref.read(stackListProvider);
    if (stackList != null &&
        ref.read(authControllerProvider).loginStatus ==
            LoginStatus.authenticated) {
      _scheduleFetch(_managedStackNames(stackList));
    }

    return const NetworkState(ports: [], globalNetworks: [], serviceCount: 0);
  }

  List<String> _managedStackNames(StackInfo stacks) => stacks.stackList.values
      .where((stack) => stack.isManagedByDockge)
      .map((stack) => stack.name)
      .toList();

  void _scheduleFetch(List<String> stackNames) {
    Future.microtask(() => fetch(stackNames));
  }

  Future<void> fetch(List<String> stackNames) async {
    final revision = ++_fetchRevision;
    if (stackNames.isEmpty) {
      state = const NetworkState(
        ports: [],
        globalNetworks: [],
        serviceCount: 0,
      );
      return;
    }

    final ports = <PortState>[];
    final globalNetworks = <GlobalNetworkState>[];
    var serviceCount = 0;
    var failedStacks = 0;

    try {
      final socket = ref.read(dockgeClientProvider).socket;
      if (socket == null) {
        ref
            .read(toastProvider.notifier)
            .showError(message: 'Not connected to server');
        return;
      }

      // Wait if authentication is in progress (e.g. reconnecting from background)
      while (ref.read(authControllerProvider).loginStatus ==
          LoginStatus.loading) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      if (ref.read(authControllerProvider).loginStatus !=
          LoginStatus.authenticated) {
        ref
            .read(toastProvider.notifier)
            .showError(message: 'Not authenticated');
        return;
      }

      for (final stackName in stackNames) {
        try {
          final response = await socket.emitAgentAsync('', 'getStack', [
            stackName,
          ]);
          if (!ref.mounted || revision != _fetchRevision) return;
          if (response is! Map ||
              response['ok'] != true ||
              response['stack'] is! Map) {
            throw FormatException('Invalid getStack response for $stackName');
          }

          final composeYaml = (response['stack'] as Map)['composeYAML'];
          if (composeYaml is! String) {
            throw FormatException('Missing composeYAML for $stackName');
          }

          final parsed = _parseStackNetwork(
            stackName: stackName,
            composeYaml: composeYaml,
          );
          ports.addAll(parsed.ports);
          serviceCount += parsed.serviceCount;
          for (final network in parsed.globalNetworks) {
            _addNetworkMember(globalNetworks, network, stackName);
          }
          for (final serviceName in parsed.hostServices) {
            _addNetworkMember(
              globalNetworks,
              'host',
              '$stackName → $serviceName',
            );
          }
        } catch (error, stackTrace) {
          failedStacks++;
          log(
            'Failed to load $stackName: $error',
            name: 'Network',
            error: error,
            stackTrace: stackTrace,
          );
        }
      }

      if (!ref.mounted || revision != _fetchRevision) return;
      ports.sort((a, b) {
        final byPort = (a.port ?? 1 << 30).compareTo(b.port ?? 1 << 30);
        return byPort != 0 ? byPort : a.stackName.compareTo(b.stackName);
      });
      for (var index = 0; index < globalNetworks.length; index++) {
        globalNetworks[index] = globalNetworks[index].copyWith(
          stackNames: [...globalNetworks[index].stackNames]..sort(),
        );
      }
      globalNetworks.sort((a, b) => a.network.compareTo(b.network));
      state = NetworkState(
        ports: ports,
        globalNetworks: globalNetworks,
        serviceCount: serviceCount,
      );

      if (failedStacks > 0) {
        ref
            .read(toastProvider.notifier)
            .showError(message: 'Failed to load $failedStacks stack(s)');
      }
    } catch (error, stackTrace) {
      log(
        error.toString(),
        name: 'Network',
        error: error,
        stackTrace: stackTrace,
      );
      if (!ref.mounted) return;
      ref
          .read(toastProvider.notifier)
          .showError(message: 'Failed to load network');
    }
  }

  void _addNetworkMember(
    List<GlobalNetworkState> networks,
    String network,
    String member,
  ) {
    final index = networks.indexWhere((item) => item.network == network);
    if (index == -1) {
      networks.add(GlobalNetworkState(network: network, stackNames: [member]));
    } else if (!networks[index].stackNames.contains(member)) {
      networks[index] = networks[index].copyWith(
        stackNames: [...networks[index].stackNames, member],
      );
    }
  }

  ({
    List<PortState> ports,
    List<String> globalNetworks,
    List<String> hostServices,
    int serviceCount,
  })
  _parseStackNetwork({required String stackName, required String composeYaml}) {
    final document = loadYaml(composeYaml);
    if (document is! Map) {
      return (
        ports: const [],
        globalNetworks: const [],
        hostServices: const [],
        serviceCount: 0,
      );
    }

    final services = document['services'];
    if (services is! Map) {
      return (
        ports: const [],
        globalNetworks: const [],
        hostServices: const [],
        serviceCount: 0,
      );
    }

    final globalAliases = _globalNetworkAliases(document['networks']);
    final ports = <PortState>[];
    final globalNetworks = <String>[];
    final hostServices = <String>[];
    var serviceCount = 0;

    for (final serviceEntry in services.entries) {
      final service = serviceEntry.value;
      if (service is! Map) continue;
      serviceCount++;

      final serviceName = serviceEntry.key.toString();
      final rawPorts = service['ports'];
      if (rawPorts is List) {
        for (final rawPort in rawPorts) {
          if (rawPort is! String && rawPort is! num && rawPort is! Map) {
            continue;
          }
          ports.add(
            PortState(
              port: _publishedPort(rawPort),
              stackName: stackName,
              serviceName: serviceName,
            ),
          );
        }
      }

      if (service['network_mode']?.toString() == 'host') {
        hostServices.add(serviceName);
      }

      for (final alias in _serviceNetworkAliases(service)) {
        final globalName = globalAliases[alias];
        if (globalName != null && !globalNetworks.contains(globalName)) {
          globalNetworks.add(globalName);
        }
      }
    }

    return (
      ports: ports,
      globalNetworks: globalNetworks,
      hostServices: hostServices,
      serviceCount: serviceCount,
    );
  }

  int? _publishedPort(dynamic rawPort) {
    if (rawPort is Map) {
      return int.tryParse(rawPort['published']?.toString() ?? '');
    }

    final mapping = PortMapping.parsePortSpec(rawPort.toString());
    return int.tryParse(mapping.hostPort ?? '');
  }

  Map<String, String> _globalNetworkAliases(dynamic rawNetworks) {
    if (rawNetworks is! Map) return const {};

    final result = <String, String>{};
    for (final entry in rawNetworks.entries) {
      final alias = entry.key.toString();
      final config = entry.value;
      if (config is! Map) continue;

      final external = config['external'];
      final explicitName = config['name']?.toString();
      final legacyExternalName = external is Map
          ? external['name']?.toString()
          : null;
      final isGlobal =
          external == true || external is Map || explicitName != null;
      if (!isGlobal) continue;

      result[alias] = switch (explicitName ?? legacyExternalName) {
        final name? when name.isNotEmpty => name,
        _ => alias,
      };
    }
    return result;
  }

  List<String> _serviceNetworkAliases(Map service) {
    final rawNetworks = service['networks'];
    if (rawNetworks is Map) {
      return rawNetworks.keys.map((key) => key.toString()).toList();
    }
    if (rawNetworks is List) {
      return rawNetworks.map((network) => network.toString()).toList();
    }

    if (service['network_mode'] == null) return const ['default'];
    return const [];
  }
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

OverviewMetrics calculateOverviewMetrics(
  StackInfo? stacks,
  NetworkState network,
) {
  final stackItems = stacks?.stackList.values.toList() ?? const <StackItem>[];
  final usedPorts = <int>[];
  for (final mapping in network.ports) {
    final port = mapping.port;
    if (port != null && !usedPorts.contains(port)) {
      usedPorts.add(port);
    }
  }

  return OverviewMetrics(
    stacks: stackItems.length,
    active: stackItems.where((stack) => stack.status == .active).length,
    exited: stackItems.where((stack) => stack.status == .exited).length,
    inactive: stackItems.where((stack) => stack.status == .inactive).length,
    services: network.serviceCount,
    ports: usedPorts.length,
  );
}

@riverpod
class Overview extends _$Overview {
  @override
  OverviewMetrics build() => calculateOverviewMetrics(
    ref.watch(stackListProvider),
    ref.watch(networkProvider),
  );
}
