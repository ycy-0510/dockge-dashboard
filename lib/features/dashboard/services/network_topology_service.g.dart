// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_topology_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(networkTopologyService)
final networkTopologyServiceProvider = NetworkTopologyServiceProvider._();

final class NetworkTopologyServiceProvider
    extends
        $FunctionalProvider<NetworkTopologyService, NetworkTopologyService, NetworkTopologyService>
    with $Provider<NetworkTopologyService> {
  NetworkTopologyServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkTopologyServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkTopologyServiceHash();

  @$internal
  @override
  $ProviderElement<NetworkTopologyService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NetworkTopologyService create(Ref ref) {
    return networkTopologyService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkTopologyService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkTopologyService>(value),
    );
  }
}

String _$networkTopologyServiceHash() => r'f91792a0e59143fac48f575c3526bffa9406d064';
