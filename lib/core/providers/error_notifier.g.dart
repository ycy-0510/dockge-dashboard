// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ErrorNotifier)
final errorProvider = ErrorNotifierProvider._();

final class ErrorNotifierProvider
    extends $NotifierProvider<ErrorNotifier, AppError?> {
  ErrorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'errorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$errorNotifierHash();

  @$internal
  @override
  ErrorNotifier create() => ErrorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppError? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppError?>(value),
    );
  }
}

String _$errorNotifierHash() => r'727abacf6ab56f985a9b5a0077729ba5f9b7740c';

abstract class _$ErrorNotifier extends $Notifier<AppError?> {
  AppError? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppError?, AppError?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppError?, AppError?>,
              AppError?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
