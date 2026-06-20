// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dockge_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DockgeClient)
final dockgeClientProvider = DockgeClientProvider._();

final class DockgeClientProvider
    extends $NotifierProvider<DockgeClient, DockgeClientState> {
  DockgeClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dockgeClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dockgeClientHash();

  @$internal
  @override
  DockgeClient create() => DockgeClient();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DockgeClientState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DockgeClientState>(value),
    );
  }
}

String _$dockgeClientHash() => r'95f5e1895d664496560c5ccbd07e8715bf1e79b8';

abstract class _$DockgeClient extends $Notifier<DockgeClientState> {
  DockgeClientState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DockgeClientState, DockgeClientState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DockgeClientState, DockgeClientState>,
              DockgeClientState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
