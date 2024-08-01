
import 'package:flutter/material.dart';

/// A class providing a utility method for creating box shadows.
class Bx {
  /// Creates a box shadow with the specified color and optional blur, spread, x, and y parameters.
  ///
  /// [color]: The color of the shadow.
  /// [blur]: The blur radius of the shadow. Default is 5.
  /// [spread]: The spread radius of the shadow. Default is 0.
  /// [x]: The horizontal offset of the shadow. Default is 0.
  /// [y]: The vertical offset of the shadow. Default is 0.
  ///
  /// Returns a box shadow instance.
  static BoxShadow shadow(Color color,
      {double? blur, double? spread, double? x, double? y}) {
    return BoxShadow(
        color: color,
        blurRadius: blur ?? 5,
        spreadRadius: spread ?? 0,
        offset: Offset(x ?? 0, y ?? 0));
  }
}
