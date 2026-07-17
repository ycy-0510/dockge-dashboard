// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composerize_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(composerizeService)
final composerizeServiceProvider = ComposerizeServiceProvider._();

final class ComposerizeServiceProvider
    extends $FunctionalProvider<ComposerizeService, ComposerizeService, ComposerizeService>
    with $Provider<ComposerizeService> {
  ComposerizeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'composerizeServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$composerizeServiceHash();

  @$internal
  @override
  $ProviderElement<ComposerizeService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ComposerizeService create(Ref ref) {
    return composerizeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ComposerizeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ComposerizeService>(value),
    );
  }
}

String _$composerizeServiceHash() => r'5fb62d163d6aa7930c3441033fb025a7c948e413';
