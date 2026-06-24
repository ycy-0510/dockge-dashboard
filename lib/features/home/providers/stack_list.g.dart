// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StackList)
final stackListProvider = StackListProvider._();

final class StackListProvider extends $NotifierProvider<StackList, StackInfo?> {
  StackListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackListHash();

  @$internal
  @override
  StackList create() => StackList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StackInfo? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StackInfo?>(value),
    );
  }
}

String _$stackListHash() => r'b9f387aa3b22d70f94f8c2a9fc3a85afaabad2d5';

abstract class _$StackList extends $Notifier<StackInfo?> {
  StackInfo? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<StackInfo?, StackInfo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StackInfo?, StackInfo?>,
              StackInfo?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
