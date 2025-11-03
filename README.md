<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

ParsedText
A lightweight Flutter widget to detect patterns in text (like links, hashtags, or mentions) and style or make them tappable.

## Features

- Parse multiple regex patterns in a single text
- Style matched patterns differently
- Add tap handlers (onTap) to matched text
- Optionally render matched text dynamically (e.g., transform @user → User)
- Simple, dependency-free, fully customizable

## Installation

Add to your pubspec.yaml:
```yaml
dependencies:
  parsed_text: ^0.0.02
```

## Usage

Import it:

```dart
import 'package:flutter/material.dart';
import 'package:parsed_text/parsed_text.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ParsedText Example')),
      body: Center(
        child: ParsedText(
          text:
              'Check out @frederick and visit https://flutter.dev for more info! #FlutterRocks 💪',
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          rules: [
            ParseRule(
              pattern: RegExp(r'@(\w+)'),
              style: const TextStyle(color: Colors.blue),
              onTap: (username) {
                debugPrint('Tapped user: $username');
              },
            ),
            ParseRule(
              pattern: RegExp(r'https?://[^\s]+'),
              style: const TextStyle(color: Colors.green),
              onTap: (url) {
                debugPrint('Tapped link: $url');
              },
            ),
            ParseRule(
              pattern: RegExp(r'#(\w+)'),
              style: const TextStyle(color: Colors.purple),
              onTap: (hashtag) {
                debugPrint('Tapped hashtag: $hashtag');
              },
            ),
          ],
        ),
      ),
    );
  }
}

```

## Test
```sh
fvm flutter test --coverage or flutter test --coverage
```