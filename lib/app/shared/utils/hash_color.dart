import 'package:flutter/widgets.dart';

abstract class HashColorGenerator {
  static const double _goldenRatioConjugate = 0.6180339887498949;

  static int _fnv1aHash(String input) {
    int hash = 0x811c9dc5;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  static (Color background, Color foreground) colorFor(
    String name,
    Brightness brightness,
  ) {
    final hash = _fnv1aHash(name);

    final normalized = (hash * _goldenRatioConjugate) % 1.0;
    final hue = normalized * 360;

    final dark = HSLColor.fromAHSL(1.0, hue, 0.45, 0.90).toColor();
    final light = HSLColor.fromAHSL(1.0, hue, 0.55, 0.35).toColor();

    return brightness == .light ? (dark, light) : (light, dark);
  }
}
