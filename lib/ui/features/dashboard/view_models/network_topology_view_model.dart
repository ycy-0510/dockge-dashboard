import 'dart:async';
import 'dart:developer';

import 'package:dockge_dashboard/ui/core/view_models/toast_notifier.dart';
import 'package:dockge_dashboard/data/repositories/dockge_stack_repository.dart';
import 'package:dockge_dashboard/domain/models/network_topology.dart';
import 'package:dockge_dashboard/domain/models/stack_models.dart';
import 'package:dockge_dashboard/domain/use_cases/calculate_overview_metrics.dart';
import 'package:dockge_dashboard/ui/features/auth/view_models/auth_view_model.dart';
import 'package:dockge_dashboard/ui/features/stacks/view_models/stack_catalog_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_topology_view_model.g.dart';

@riverpod
class NetworkTopologyViewModel extends _$NetworkTopologyViewModel {
  int _fetchRevision = 0;

  @override
  NetworkTopology build() {
    ref.listen(stackCatalogViewModelProvider, (previous, next) {
      if (next != null && !identical(previous, next)) {
        _scheduleFetch(next);
      }
    });
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.loginStatus == LoginStatus.authenticated &&
          previous?.loginStatus != LoginStatus.authenticated) {
        final catalog = ref.read(stackCatalogViewModelProvider);
        if (catalog != null) _scheduleFetch(catalog);
      }
    });

    final catalog = ref.read(stackCatalogViewModelProvider);
    if (catalog != null &&
        ref.read(authViewModelProvider).loginStatus == LoginStatus.authenticated) {
      _scheduleFetch(catalog);
    }
    return const NetworkTopology.empty();
  }

  void _scheduleFetch(StackCatalog catalog) {
    Future<void>.microtask(() => fetch(catalog));
  }

  Future<void> fetch(StackCatalog catalog) async {
    final revision = ++_fetchRevision;
    final stackNames = catalog.stacks
        .where((stack) => stack.isManagedByDockge)
        .map((stack) => stack.name)
        .toList(growable: false);
    if (stackNames.isEmpty) {
      state = const NetworkTopology.empty();
      return;
    }
    if (ref.read(authViewModelProvider).loginStatus != LoginStatus.authenticated) {
      return;
    }

    final ports = <PublishedPort>[];
    final networkMembers = <String, Set<String>>{};
    var serviceCount = 0;
    var failedStacks = 0;
    final repository = ref.read(stackRepositoryProvider);

    for (final stackName in stackNames) {
      try {
        final snapshot = await repository.fetchNetwork(stackName);
        if (!ref.mounted || revision != _fetchRevision) return;
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
          name: 'NetworkTopologyViewModel',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    if (!ref.mounted || revision != _fetchRevision) return;
    ports.sort((left, right) {
      final byPort = (left.port ?? 1 << 30).compareTo(right.port ?? 1 << 30);
      return byPort != 0 ? byPort : left.stackName.compareTo(right.stackName);
    });
    final externalNetworks = [
      for (final entry in networkMembers.entries)
        ExternalNetwork(name: entry.key, members: entry.value.toList()..sort()),
    ]..sort((left, right) => left.name.compareTo(right.name));
    state = NetworkTopology(
      ports: ports,
      externalNetworks: externalNetworks,
      serviceCount: serviceCount,
    );

    if (failedStacks > 0) {
      ref.read(toastProvider.notifier).showError(message: 'Failed to load $failedStacks stack(s)');
    }
  }
}

@riverpod
OverviewMetrics overviewMetrics(Ref ref) => calculateOverviewMetrics(
  ref.watch(stackCatalogViewModelProvider),
  ref.watch(networkTopologyViewModelProvider),
);
