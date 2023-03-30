import 'dart:ui';

extension ColorExt on Color {
  // Add over top
  Color operator +(Color other) => Color.alphaBlend(other, this);
}
