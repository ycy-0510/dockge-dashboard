import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:local_auth/local_auth.dart';

part 'local_auth.g.dart';

@riverpod
LocalAuthentication localAuth(Ref ref) => LocalAuthentication();
