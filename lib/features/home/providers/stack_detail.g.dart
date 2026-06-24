// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StackDetail)
final stackDetailProvider = StackDetailProvider._();

final class StackDetailProvider
    extends $NotifierProvider<StackDetail, StackDetailInfo?> {
  StackDetailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackDetailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackDetailHash();

  @$internal
  @override
  StackDetail create() => StackDetail();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StackDetailInfo? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StackDetailInfo?>(value),
    );
  }
}

String _$stackDetailHash() => r'4c5e8152a76b13bdfe7218208bc78ba67fbe2204';

abstract class _$StackDetail extends $Notifier<StackDetailInfo?> {
  StackDetailInfo? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<StackDetailInfo?, StackDetailInfo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StackDetailInfo?, StackDetailInfo?>,
              StackDetailInfo?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
