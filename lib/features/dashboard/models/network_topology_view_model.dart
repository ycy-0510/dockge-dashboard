import 'dart:async';

import 'package:dockge_dashboard/app/shared/toast/toast_notifier.dart';
import 'package:dockge_dashboard/features/dashboard/models/network_topology.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_models.dart';
import 'package:dockge_dashboard/features/dashboard/services/calculate_overview_metrics.dart';
import 'package:dockge_dashboard/features/dashboard/services/network_topology_service.dart';
import 'package:dockge_dashboard/features/auth/models/auth_view_model.dart';
import 'package:dockge_dashboard/features/stacks/models/stack_catalog_view_model.dart';
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
    if (ref.read(authViewModelProvider).loginStatus != LoginStatus.authenticated) {
      return;
    }

    final result = await ref.read(networkTopologyServiceProvider).load(catalog);
    if (!ref.mounted || revision != _fetchRevision) return;
    state = result.topology;

    if (result.failedStackCount > 0) {
      ref
          .read(toastProvider.notifier)
          .showError(message: 'Failed to load ${result.failedStackCount} stack(s)');
    }
  }
}

@riverpod
OverviewMetrics overviewMetrics(Ref ref) => calculateOverviewMetrics(
  ref.watch(stackCatalogViewModelProvider),
  ref.watch(networkTopologyViewModelProvider),
);
