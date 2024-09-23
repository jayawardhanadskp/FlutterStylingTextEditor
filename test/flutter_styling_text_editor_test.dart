import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_styling_text_editor/flutter_styling_text_editor.dart';

void main() {
  group('StyledTextEditor Tests', () {
    testWidgets('Should render initial text correctly', (WidgetTester tester) async {
      // Create a controller with initial text
      final TextEditingController controller = TextEditingController(text: 'Hello');
      String resultText = '';

      // Build StyledTextEditor widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StyledTextEditor(
            controller: controller,
            onTextChange: (text) {
              resultText = text;
            },
          ),
        ),
      ));

      // Check if the initial text is displayed
      expect(find.text('Hello'), findsOneWidget);

      // Enter new text
      await tester.enterText(find.byType(TextField), 'Hello World');
      await tester.pump();

      // Check that the text has been updated
      expect(resultText, contains('Hello World'));
    });

    testWidgets('Should apply bold style correctly', (WidgetTester tester) async {
      // Create a controller with initial text
      final TextEditingController controller = TextEditingController();
      String resultText = '';

      // Build StyledTextEditor widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StyledTextEditor(
            controller: controller,
            onTextChange: (text) {
              resultText = text;
            },
          ),
        ),
      ));

      // Enter text
      await tester.enterText(find.byType(TextField), 'Bold Text');
      await tester.pump();

      // Tap the bold button
      await tester.tap(find.byIcon(Icons.format_bold));
      await tester.pump();

      // Enter text again to trigger the bold format
      await tester.enterText(find.byType(TextField), 'Bold Text');
      await tester.pump();

      // Check if bold style has been applied
      expect(resultText, contains('**Bold Text**'));
    });
  });

  group('StyledTextPreview Tests', () {
    testWidgets('Should parse and display styled text correctly', (WidgetTester tester) async {
      // Text with bold, italic and underline styles
      const String styledText = '**Bold** *Italic* __Underline__';

      // Build StyledTextPreview widget
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: StyledTextPreview(
            text: styledText,
          ),
        ),
      ));

      // Check if the parsed styled text is displayed correctly
      expect(find.text('Bold'), findsOneWidget);
      expect(find.text('Italic'), findsOneWidget);
      expect(find.text('Underline'), findsOneWidget);
    });
  });
}
