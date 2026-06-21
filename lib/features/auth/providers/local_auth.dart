import 'package:dockge_dashboard/core/network/dockge_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:local_auth/local_auth.dart';

part 'local_auth.g.dart';

@riverpod
LocalAuthentication localAuth(Ref ref) => LocalAuthentication();

@riverpod
Future<bool> canLocalAuthenticate(Ref ref) async {
  final auth = ref.watch(localAuthProvider);
  return await auth.canCheckBiometrics || await auth.isDeviceSupported();
}

@riverpod
Future<List<BiometricType>> availableBiometrics(Ref ref) async {
  return ref.watch(localAuthProvider).getAvailableBiometrics();
}

@riverpod
bool readyForBiometric(Ref ref) {
  final connected = ref.watch(dockgeClientProvider).status == .connected;

  final canAuth = ref.watch(canLocalAuthenticateProvider).value ?? false;

  final hasStrongBio =
      ref
          .watch(availableBiometricsProvider)
          .value
          ?.any(
            (t) => const {
              BiometricType.face,
              BiometricType.fingerprint,
              BiometricType.iris,
            }.contains(t),
          ) ??
      false;

  return connected && canAuth && hasStrongBio;
}
