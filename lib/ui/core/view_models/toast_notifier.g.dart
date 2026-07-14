// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toast_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ToastNotifier)
final toastProvider = ToastNotifierProvider._();

final class ToastNotifierProvider extends $NotifierProvider<ToastNotifier, ToastMessage?> {
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
  Override overrideWithValue(ToastMessage? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToastMessage?>(value),
    );
  }
}

String _$toastNotifierHash() => r'bc095b75171e574daafabffe06788976513867a9';

abstract class _$ToastNotifier extends $Notifier<ToastMessage?> {
  ToastMessage? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ToastMessage?, ToastMessage?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ToastMessage?, ToastMessage?>,
              ToastMessage?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
