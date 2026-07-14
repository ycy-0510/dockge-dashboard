// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Network)
final networkProvider = NetworkProvider._();

final class NetworkProvider extends $NotifierProvider<Network, NetworkState> {
  NetworkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkHash();

  @$internal
  @override
  Network create() => Network();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkState>(value),
    );
  }
}

String _$networkHash() => r'8874fbd6f045ed18c1be417b6b163021944a1d45';

abstract class _$Network extends $Notifier<NetworkState> {
  NetworkState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NetworkState, NetworkState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NetworkState, NetworkState>,
              NetworkState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(Overview)
final overviewProvider = OverviewProvider._();

final class OverviewProvider
    extends $NotifierProvider<Overview, OverviewMetrics> {
  OverviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overviewHash();

  @$internal
  @override
  Overview create() => Overview();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OverviewMetrics value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OverviewMetrics>(value),
    );
  }
}

String _$overviewHash() => r'da194054f0571af747bab1c490b94b4b7691ab63';

abstract class _$Overview extends $Notifier<OverviewMetrics> {
  OverviewMetrics build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OverviewMetrics, OverviewMetrics>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OverviewMetrics, OverviewMetrics>,
              OverviewMetrics,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
