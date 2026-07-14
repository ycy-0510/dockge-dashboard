import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'prefs.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences prefs(Ref ref) {
  throw UnimplementedError('prefsProvider must be overridden');
}

final class PrefsStore {
  const PrefsStore(this._preferences);

  final SharedPreferences _preferences;

  String? readEndpoint() => _preferences.getString(PrefsKey.endpoint);

  Future<void> writeEndpoint(String endpoint) =>
      _preferences.setString(PrefsKey.endpoint, endpoint);
}

@Riverpod(keepAlive: true)
PrefsStore prefsStore(Ref ref) => PrefsStore(ref.watch(prefsProvider));

abstract final class PrefsKey {
  static const endpoint = "endpoint";
}
