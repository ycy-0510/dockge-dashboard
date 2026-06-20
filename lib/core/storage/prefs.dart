import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences prefs(Ref ref) {
  throw UnimplementedError('prefsProvider must be overridden');
}

abstract final class PrefsKey {
  static const endpoint = "endpoint";
}
