final class WireFormatException implements FormatException {
  const WireFormatException(this.message, {this.source, this.offset});

  @override
  final String message;

  @override
  final Object? source;

  @override
  final int? offset;

  @override
  String toString() => 'WireFormatException: $message';
}

final class WireObject {
  WireObject._(this._values);

  final Map<Object?, Object?> _values;

  static WireObject parse(Object? value, {required String context}) {
    final parsed = tryParse(value);
    if (parsed == null) {
      throw WireFormatException('$context must be an object', source: value);
    }
    return parsed;
  }

  static WireObject? tryParse(Object? value) => switch (value) {
    final Map<Object?, Object?> values => WireObject._(values),
    _ => null,
  };

  bool contains(String key) => _values.containsKey(key);

  Object? value(String key) => _values[key];

  Iterable<(String, Object?)> get entries sync* {
    for (final entry in _values.entries) {
      if (entry.key case final String key) yield (key, entry.value);
    }
  }

  String requireString(String key) {
    final result = _values[key];
    if (result is String) return result;
    throw WireFormatException('$key must be a string', source: result);
  }

  String stringOr(String key, String fallback) => switch (_values[key]) {
    final String value => value,
    null => fallback,
    final Object value => value.toString(),
  };

  bool requireBool(String key) {
    final result = _values[key];
    if (result is bool) return result;
    throw WireFormatException('$key must be a boolean', source: result);
  }

  WireObject requireObject(String key) => WireObject.parse(_values[key], context: key);

  Iterable<(String, WireObject)> get objectEntries sync* {
    for (final entry in _values.entries) {
      final key = entry.key;
      final value = WireObject.tryParse(entry.value);
      if (key is String && value != null) yield (key, value);
    }
  }
}
