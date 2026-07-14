// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dockge_stack_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stackRepository)
final stackRepositoryProvider = StackRepositoryProvider._();

final class StackRepositoryProvider
    extends $FunctionalProvider<StackRepository, StackRepository, StackRepository>
    with $Provider<StackRepository> {
  StackRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stackRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stackRepositoryHash();

  @$internal
  @override
  $ProviderElement<StackRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StackRepository create(Ref ref) {
    return stackRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StackRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StackRepository>(value),
    );
  }
}

String _$stackRepositoryHash() => r'84339d56c4695993aa7dd26e84b6d51e7d254af2';
