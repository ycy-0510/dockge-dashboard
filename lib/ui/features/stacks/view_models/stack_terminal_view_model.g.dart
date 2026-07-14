// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_terminal_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StackTerminalViewModel)
final stackTerminalViewModelProvider = StackTerminalViewModelProvider._();

final class StackTerminalViewModelProvider
    extends $NotifierProvider<StackTerminalViewModel, StackTerminalViewState?> {
  StackTerminalViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackTerminalViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackTerminalViewModelHash();

  @$internal
  @override
  StackTerminalViewModel create() => StackTerminalViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StackTerminalViewState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StackTerminalViewState?>(value),
    );
  }
}

String _$stackTerminalViewModelHash() => r'eb5a3250845d6403e842e54f8da889db93726f21';

abstract class _$StackTerminalViewModel extends $Notifier<StackTerminalViewState?> {
  StackTerminalViewState? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<StackTerminalViewState?, StackTerminalViewState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StackTerminalViewState?, StackTerminalViewState?>,
              StackTerminalViewState?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
