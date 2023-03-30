import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerUtils {
  static Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static buildShimmerWithText(TextStyle style,
      {String? text, Size? addMore, double? borderRadius}) {
    final size = _textSize(text ?? "Shimmer", style);
    return buildShimmer(
        borderRadius: borderRadius,
        height: size.height + (addMore?.height ?? 0),
        width: size.width + (addMore?.width ?? 0));
  }

  static buildShimmer(
      {double? height, double? width, Widget? child, double? borderRadius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: child ??
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 0),
              color: Colors.grey,
            ),
            height: height,
            width: width,
          ),
    );
  }
}
