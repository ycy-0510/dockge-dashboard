// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dockge_api_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dockgeApiService)
final dockgeApiServiceProvider = DockgeApiServiceProvider._();

final class DockgeApiServiceProvider
    extends $FunctionalProvider<DockgeApiService, DockgeApiService, DockgeApiService>
    with $Provider<DockgeApiService> {
  DockgeApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dockgeApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dockgeApiServiceHash();

  @$internal
  @override
  $ProviderElement<DockgeApiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DockgeApiService create(Ref ref) {
    return dockgeApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DockgeApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DockgeApiService>(value),
    );
  }
}

String _$dockgeApiServiceHash() => r'0fdec8fe09eb3372d940669d1665d479bab1be14';
