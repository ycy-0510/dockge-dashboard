// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prefs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(prefs)
final prefsProvider = PrefsProvider._();

final class PrefsProvider
    extends $FunctionalProvider<SharedPreferences, SharedPreferences, SharedPreferences>
    with $Provider<SharedPreferences> {
  PrefsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prefsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prefsHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return prefs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$prefsHash() => r'1436193465881d4999426192f3e760b8dc25fc13';

@ProviderFor(prefsStore)
final prefsStoreProvider = PrefsStoreProvider._();

final class PrefsStoreProvider extends $FunctionalProvider<PrefsStore, PrefsStore, PrefsStore>
    with $Provider<PrefsStore> {
  PrefsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prefsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prefsStoreHash();

  @$internal
  @override
  $ProviderElement<PrefsStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrefsStore create(Ref ref) {
    return prefsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrefsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrefsStore>(value),
    );
  }
}

String _$prefsStoreHash() => r'42e9f73b7a3e1f9b3601aff39210b17fd1100d72';
