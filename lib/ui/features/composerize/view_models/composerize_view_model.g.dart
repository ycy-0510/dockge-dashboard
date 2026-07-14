// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composerize_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ComposerizeViewModel)
final composerizeViewModelProvider = ComposerizeViewModelProvider._();

final class ComposerizeViewModelProvider extends $NotifierProvider<ComposerizeViewModel, bool> {
  ComposerizeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'composerizeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$composerizeViewModelHash();

  @$internal
  @override
  ComposerizeViewModel create() => ComposerizeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$composerizeViewModelHash() => r'e87ba9e6ca33ffd3eea2cfa5ea051786747a89e1';

abstract class _$ComposerizeViewModel extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<bool, bool>, bool, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
