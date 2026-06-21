// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localAuth)
final localAuthProvider = LocalAuthProvider._();

final class LocalAuthProvider
    extends
        $FunctionalProvider<
          LocalAuthentication,
          LocalAuthentication,
          LocalAuthentication
        >
    with $Provider<LocalAuthentication> {
  LocalAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localAuthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localAuthHash();

  @$internal
  @override
  $ProviderElement<LocalAuthentication> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalAuthentication create(Ref ref) {
    return localAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalAuthentication value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalAuthentication>(value),
    );
  }
}

String _$localAuthHash() => r'00a183e0c60bf972ee17c3e876f9d314c6d4eeb7';

@ProviderFor(canLocalAuthenticate)
final canLocalAuthenticateProvider = CanLocalAuthenticateProvider._();

final class CanLocalAuthenticateProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  CanLocalAuthenticateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canLocalAuthenticateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canLocalAuthenticateHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canLocalAuthenticate(ref);
  }
}

String _$canLocalAuthenticateHash() =>
    r'6870faa6c496b82670a3df6acf156a01ea0b5a6c';

@ProviderFor(availableBiometrics)
final availableBiometricsProvider = AvailableBiometricsProvider._();

final class AvailableBiometricsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BiometricType>>,
          List<BiometricType>,
          FutureOr<List<BiometricType>>
        >
    with
        $FutureModifier<List<BiometricType>>,
        $FutureProvider<List<BiometricType>> {
  AvailableBiometricsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableBiometricsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableBiometricsHash();

  @$internal
  @override
  $FutureProviderElement<List<BiometricType>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BiometricType>> create(Ref ref) {
    return availableBiometrics(ref);
  }
}

String _$availableBiometricsHash() =>
    r'ed7b2e5037122281aef8482827eb289ab7713431';

@ProviderFor(readyForBiometric)
final readyForBiometricProvider = ReadyForBiometricProvider._();

final class ReadyForBiometricProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  ReadyForBiometricProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readyForBiometricProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readyForBiometricHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return readyForBiometric(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$readyForBiometricHash() => r'88ff547308712bf04b15c77ff989b3aaf19929ac';
