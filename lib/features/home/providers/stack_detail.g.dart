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

String _$stackDetailHash() => r'2aae4266e4670d146dbcb6c2006292cfda70a6fc';

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

@ProviderFor(StackTerminal)
final stackTerminalProvider = StackTerminalProvider._();

final class StackTerminalProvider
    extends $NotifierProvider<StackTerminal, StackTerminalState?> {
  StackTerminalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackTerminalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackTerminalHash();

  @$internal
  @override
  StackTerminal create() => StackTerminal();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StackTerminalState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StackTerminalState?>(value),
    );
  }
}

String _$stackTerminalHash() => r'02a729ffd85bcdb1567e767a012c35a04f4eb225';

abstract class _$StackTerminal extends $Notifier<StackTerminalState?> {
  StackTerminalState? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<StackTerminalState?, StackTerminalState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StackTerminalState?, StackTerminalState?>,
              StackTerminalState?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
