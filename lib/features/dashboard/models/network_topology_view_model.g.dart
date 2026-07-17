// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_topology_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NetworkTopologyViewModel)
final networkTopologyViewModelProvider = NetworkTopologyViewModelProvider._();

final class NetworkTopologyViewModelProvider
    extends $NotifierProvider<NetworkTopologyViewModel, NetworkTopology> {
  NetworkTopologyViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkTopologyViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkTopologyViewModelHash();

  @$internal
  @override
  NetworkTopologyViewModel create() => NetworkTopologyViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkTopology value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkTopology>(value),
    );
  }
}

String _$networkTopologyViewModelHash() => r'dfc623af29cd9b3acfee1b6ea27447974b053f53';

abstract class _$NetworkTopologyViewModel extends $Notifier<NetworkTopology> {
  NetworkTopology build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NetworkTopology, NetworkTopology>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkTopology, NetworkTopology>,
              NetworkTopology,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(overviewMetrics)
final overviewMetricsProvider = OverviewMetricsProvider._();

final class OverviewMetricsProvider
    extends $FunctionalProvider<OverviewMetrics, OverviewMetrics, OverviewMetrics>
    with $Provider<OverviewMetrics> {
  OverviewMetricsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overviewMetricsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overviewMetricsHash();

  @$internal
  @override
  $ProviderElement<OverviewMetrics> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OverviewMetrics create(Ref ref) {
    return overviewMetrics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OverviewMetrics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OverviewMetrics>(value),
    );
  }
}

String _$overviewMetricsHash() => r'6b7d36b7ab35e27bd49418394aabd8aff674e0fc';
