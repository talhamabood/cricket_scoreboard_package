import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cricket_scoreboard/cricket_scoreboard.dart';

void main() {
  testWidgets('MyCustomContainer displays the correct text', (WidgetTester tester) async {
    const testText = 'Hello Widget!';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MyCustomContainer(text: testText),
        ),
      ),
    );

    expect(find.text(testText), findsOneWidget);
  });

  testWidgets('MyCustomContainer has the correct style', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MyCustomContainer(text: 'Test'),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container));
    final decoration = container.decoration as BoxDecoration;

    expect(decoration.color, Colors.blue);
    expect(decoration.borderRadius, BorderRadius.circular(12));
  });
}
