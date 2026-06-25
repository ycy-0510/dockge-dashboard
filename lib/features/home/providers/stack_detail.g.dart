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

String _$stackDetailHash() => r'4222b3ccced3072bee85c48a2de8f3241e87bea3';

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
    extends $NotifierProvider<StackTerminal, Terminal> {
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
  Override overrideWithValue(Terminal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Terminal>(value),
    );
  }
}

String _$stackTerminalHash() => r'2f5a45d57051f0bf4abc216155c74cd89bfc5ca3';

abstract class _$StackTerminal extends $Notifier<Terminal> {
  Terminal build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Terminal, Terminal>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Terminal, Terminal>,
              Terminal,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
