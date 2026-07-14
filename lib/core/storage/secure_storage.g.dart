// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

final class SecureStorageProvider
    extends $FunctionalProvider<FlutterSecureStorage, FlutterSecureStorage, FlutterSecureStorage>
    with $Provider<FlutterSecureStorage> {
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'56392082011497ecf7eb752438c9b337891e0494';

@ProviderFor(secureTokenStore)
final secureTokenStoreProvider = SecureTokenStoreProvider._();

final class SecureTokenStoreProvider
    extends $FunctionalProvider<SecureTokenStore, SecureTokenStore, SecureTokenStore>
    with $Provider<SecureTokenStore> {
  SecureTokenStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureTokenStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureTokenStoreHash();

  @$internal
  @override
  $ProviderElement<SecureTokenStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SecureTokenStore create(Ref ref) {
    return secureTokenStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureTokenStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureTokenStore>(value),
    );
  }
}

String _$secureTokenStoreHash() => r'7c1367270e01d8837be926c70602a5b1ce395562';
