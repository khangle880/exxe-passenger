import 'package:flutter/widgets.dart';

class RegexTextSpanBuilder {
  static TextSpan buildTextSpan({
    Map<RegExp, TextStyle>? patternMatchMap,
    Map<String, TextStyle>? stringMatchMap,
    required TextStyle style,
    required String text,
  }) {
    assert((patternMatchMap != null && stringMatchMap == null) ||
        (patternMatchMap == null && stringMatchMap != null));
    List<TextSpan> children = [];
    List<String> matches = [];

    // Validating with REGEX
    RegExp? allRegex;
    allRegex = patternMatchMap != null
        ? RegExp(patternMatchMap.keys.map((e) => e.pattern).join('|'))
        : null;
    // Validating with Strings
    RegExp? stringRegex;
    stringRegex = stringMatchMap != null
        ? RegExp(r'\b' + stringMatchMap.keys.join('|').toString() + r'+\b')
        : null;
    ////
    text.splitMapJoin(
      stringMatchMap == null ? allRegex! : stringRegex!,
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
        return span.toString();
      },
      onMatch: (Match m) {
        if (!matches.contains(m[0])) matches.add(m[0]!);
        final RegExp? k = patternMatchMap?.entries.firstWhere((element) {
          return element.key.allMatches(m[0]!).isNotEmpty;
        }).key;
        final String? ks = stringMatchMap?.entries.firstWhere((element) {
          return element.key.allMatches(m[0]!).isNotEmpty;
        }).key;
        children.add(
          TextSpan(
            text: m[0],
            style: stringMatchMap == null
                ? patternMatchMap![k]
                : stringMatchMap[ks],
          ),
        );

        return ('');
      },
    );
    return TextSpan(style: style, children: children);
  }
}
