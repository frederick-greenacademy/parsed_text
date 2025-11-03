import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef RenderTextCallback = String Function({
  required String str,
  required Pattern pattern,
});

class ParseRule {
  final RegExp pattern;
  final TextStyle? style;
  final void Function(String match)? onTap;
  final RenderTextCallback? renderText;

  const ParseRule({
    required this.pattern,
    this.style,
    this.onTap,
    this.renderText,
  });
}

class ParsedText extends StatelessWidget {
  final String text;
  final List<ParseRule> rules;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const ParsedText({
    super.key,
    required this.text,
    required this.rules,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    int currentIndex = 0;

    // Find all matches of all rules
    final matches = <_MatchInfo>[];

    for (final rule in rules) {
      for (final match in rule.pattern.allMatches(text)) {
        matches.add(_MatchInfo(
          start: match.start,
          end: match.end,
          text: match.group(0)!,
          rule: rule,
        ));
      }
    }

    // Sort matches by order in text
    matches.sort((a, b) => a.start.compareTo(b.start));

    // Merge non-overlapping segments
    for (final match in matches) {
      if (match.start >= currentIndex) {
        // normal text before match
        if (match.start > currentIndex) {
          spans.add(TextSpan(
            text: text.substring(currentIndex, match.start),
            style: style,
          ));
        }

        final displayedText = match.rule.renderText != null
            ? match.rule.renderText!(
                str: match.text,
                pattern: match.rule.pattern,
              )
            : match.text;

        spans.add(TextSpan(
          text: displayedText,
          style: match.rule.style ?? style,
          recognizer: match.rule.onTap != null
              ? (TapGestureRecognizer()
                ..onTap = () => match.rule.onTap!(match.text))
              : null,
        ));

        currentIndex = match.end;
      }
    }


    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: style,
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

class _MatchInfo {
  final int start;
  final int end;
  final String text;
  final ParseRule rule;

  _MatchInfo({
    required this.start,
    required this.end,
    required this.text,
    required this.rule,
  });
}
