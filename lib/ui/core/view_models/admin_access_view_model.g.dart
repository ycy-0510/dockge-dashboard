// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_access_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminAccessViewModel)
final adminAccessViewModelProvider = AdminAccessViewModelProvider._();

final class AdminAccessViewModelProvider extends $NotifierProvider<AdminAccessViewModel, bool> {
  AdminAccessViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminAccessViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminAccessViewModelHash();

  @$internal
  @override
  AdminAccessViewModel create() => AdminAccessViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$adminAccessViewModelHash() => r'56bdc325029929d4e239791ab65dc77e4d0f4288';

abstract class _$AdminAccessViewModel extends $Notifier<bool> {
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
