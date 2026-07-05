// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toast_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ToastNotifier)
final toastProvider = ToastNotifierProvider._();

final class ToastNotifierProvider
    extends $NotifierProvider<ToastNotifier, ToastMsg?> {
  ToastNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toastProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toastNotifierHash();

  @$internal
  @override
  ToastNotifier create() => ToastNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToastMsg? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToastMsg?>(value),
    );
  }
}

String _$toastNotifierHash() => r'e4c6545cf5af7eba8dfbfe802b7b91f65b14eda0';

abstract class _$ToastNotifier extends $Notifier<ToastMsg?> {
  ToastMsg? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ToastMsg?, ToastMsg?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ToastMsg?, ToastMsg?>,
              ToastMsg?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
