import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parsed_text/parsed_text.dart';

void main() {
  testWidgets('renders plain text correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ParsedText(
          text: 'Hello World',
          rules: [],
        ),
      ),
    );

    expect(find.text('Hello World'), findsOneWidget);
  });

  testWidgets('applies custom style to matched text', (WidgetTester tester) async {
    final rule = ParseRule(
      pattern: RegExp(r'@(\w+)'),
      style: const TextStyle(color: Colors.blue),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ParsedText(
          text: 'Hi @Frederick!',
          rules: [rule],
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.byType(Text));
    final textSpan = textWidget.textSpan as TextSpan;

    // Expect "@Frederick" span has custom style
    final spans = (textSpan.children ?? []).whereType<TextSpan>().toList();
    final matchedSpan = spans.firstWhere(
      (span) => span.text!.contains('@Frederick'),
    );

    expect(matchedSpan.style?.color, equals(Colors.blue));
  });

  testWidgets('calls onTap when a matched pattern is tapped', (WidgetTester tester) async {
    String? tapped;

    final rule = ParseRule(
      pattern: RegExp(r'#(\w+)'),
      style: const TextStyle(color: Colors.purple),
      onTap: (match) => tapped = match,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ParsedText(
            text: 'Go #Flutter!',
            rules: [rule],
          ),
        ),
      ),
    );

    // Tap the text (this will trigger TapGestureRecognizer)
    await tester.tap(find.byType(ParsedText));
    await tester.pump();

    expect(tapped, equals('#Flutter'));
  });

  testWidgets('renders custom text using renderText callback', (WidgetTester tester) async {
    final rule = ParseRule(
      pattern: RegExp(r'https?://[^\s]+'),
      renderText: ({required str, required pattern}) => '🔗 Link',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ParsedText(
          text: 'Visit https://flutter.dev today!',
          rules: [rule],
        ),
      ),
    );

    expect(find.textContaining('🔗 Link'), findsOneWidget);
    expect(find.textContaining('https://flutter.dev'), findsNothing);
  });

  testWidgets('handles overlapping regex patterns correctly', (WidgetTester tester) async {
    final rules = [
      ParseRule(pattern: RegExp(r'@(\w+)')),
      ParseRule(pattern: RegExp(r'(\w+)')),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: ParsedText(
          text: '@Flutter',
          rules: rules,
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.byType(Text));
    final text = (textWidget.textSpan as TextSpan).toPlainText();

    expect(text, equals('@Flutter'));
  });
}
