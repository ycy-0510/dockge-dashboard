// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_details_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StackDetailsViewModel)
final stackDetailsViewModelProvider = StackDetailsViewModelProvider._();

final class StackDetailsViewModelProvider
    extends $NotifierProvider<StackDetailsViewModel, StackDetailsViewState> {
  StackDetailsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackDetailsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackDetailsViewModelHash();

  @$internal
  @override
  StackDetailsViewModel create() => StackDetailsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StackDetailsViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StackDetailsViewState>(value),
    );
  }
}

String _$stackDetailsViewModelHash() => r'b85911d31dd8429f7ca08a6988d96d633745a480';

abstract class _$StackDetailsViewModel extends $Notifier<StackDetailsViewState> {
  StackDetailsViewState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<StackDetailsViewState, StackDetailsViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StackDetailsViewState, StackDetailsViewState>,
              StackDetailsViewState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
