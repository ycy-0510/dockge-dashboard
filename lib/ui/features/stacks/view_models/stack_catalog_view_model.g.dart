// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_catalog_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StackCatalogViewModel)
final stackCatalogViewModelProvider = StackCatalogViewModelProvider._();

final class StackCatalogViewModelProvider
    extends $NotifierProvider<StackCatalogViewModel, StackCatalog?> {
  StackCatalogViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackCatalogViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackCatalogViewModelHash();

  @$internal
  @override
  StackCatalogViewModel create() => StackCatalogViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StackCatalog? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StackCatalog?>(value),
    );
  }
}

String _$stackCatalogViewModelHash() => r'b8a3fd914cc8c0ae090d9315c045cd048d05b404';

abstract class _$StackCatalogViewModel extends $Notifier<StackCatalog?> {
  StackCatalog? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<StackCatalog?, StackCatalog?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StackCatalog?, StackCatalog?>,
              StackCatalog?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
