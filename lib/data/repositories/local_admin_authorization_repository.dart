import 'package:dockge_dashboard/domain/repositories/admin_authorization_repository.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_admin_authorization_repository.g.dart';

final class LocalAdminAuthorizationRepository implements AdminAuthorizationRepository {
  const LocalAdminAuthorizationRepository(this._localAuthentication);

  final LocalAuthentication _localAuthentication;

  @override
  Future<bool> authorize() async {
    try {
      return await _localAuthentication.authenticate(
        localizedReason: 'Verify identity for admin access',
      );
    } on LocalAuthException catch (error) {
      throw AdminAuthorizationException(error.description ?? error.toString());
    }
  }
}

@riverpod
LocalAuthentication localAuthentication(Ref ref) => LocalAuthentication();

@riverpod
AdminAuthorizationRepository adminAuthorizationRepository(Ref ref) =>
    LocalAdminAuthorizationRepository(ref.watch(localAuthenticationProvider));
