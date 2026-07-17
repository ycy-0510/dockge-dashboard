// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_admin_authorization_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localAuthentication)
final localAuthenticationProvider = LocalAuthenticationProvider._();

final class LocalAuthenticationProvider
    extends $FunctionalProvider<LocalAuthentication, LocalAuthentication, LocalAuthentication>
    with $Provider<LocalAuthentication> {
  LocalAuthenticationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localAuthenticationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localAuthenticationHash();

  @$internal
  @override
  $ProviderElement<LocalAuthentication> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalAuthentication create(Ref ref) {
    return localAuthentication(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalAuthentication value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalAuthentication>(value),
    );
  }
}

String _$localAuthenticationHash() => r'2c2b36bdc9ccdb2995310d7634b8ef61ed4a6746';

@ProviderFor(adminAuthorizationRepository)
final adminAuthorizationRepositoryProvider = AdminAuthorizationRepositoryProvider._();

final class AdminAuthorizationRepositoryProvider
    extends
        $FunctionalProvider<
          AdminAuthorizationRepository,
          AdminAuthorizationRepository,
          AdminAuthorizationRepository
        >
    with $Provider<AdminAuthorizationRepository> {
  AdminAuthorizationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminAuthorizationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminAuthorizationRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminAuthorizationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminAuthorizationRepository create(Ref ref) {
    return adminAuthorizationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminAuthorizationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminAuthorizationRepository>(value),
    );
  }
}

String _$adminAuthorizationRepositoryHash() => r'f8565f7358f5784d5aa313c6a76c6bf8b89e39eb';
