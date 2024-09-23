
# Flutter Styling Text Editor

Flutter Styling Text Editor is a lightweight package that allows you to easily edit and preview styled text in Flutter applications. **This sopports all of the platforms.** The package provides a customizable text editor where users can apply styles like **bold**, *italic*, and __underline__ to the text. Once the text is styled, you can save the styled result to a database and retrieve it later for preview or further use. This package is ideal for admin panels where administrators need to input and manage styled content that users can view in a mobile or web app.

## Features
- Rich text editing with styles like **Bold**, *Italic*, and __Underline__.
- Save the styled text result for later use (e.g., store it in a database).
- Directly use the styled text from a variable without saving.
- Preview styled text using a separate widget, `StyledTextPreview`.
- Simple and easy to integrate into any Flutter project.



## Getting Started

To use this package, add the following line to your `pubspec.yaml` under dependencies:

```yaml
dependencies:
  flutter_styling_text_editor: ^0.1.0  
```
Then run:
```dart
  flutter pub get
```

## Example Usage

Here’s an example of how to use the `StyledTextEditor` and `StyledTextPreview` widgets:

### 1. Import the package

```dart
import 'package:flutter_styling_text_editor/flutter_styling_text_editor.dart';
```

### 2. Create a text editor

Use `StyledTextEditor` to create a customizable text editor where users can type their styled text.

```dart
final TextEditingController _textController = TextEditingController();
String _finalStyledText = ''; // Store generated styled text

StyledTextEditor(
  controller: _textController,
  onTextChange: (result) {
    setState(() {
      _finalStyledText = result;  // The final result will be stored here
    });
  },
);
```

### 3. Saving the styled text or directly using the result

You can either store the `_finalStyledText` in a database (local storage or cloud database) for later use or directly utilize it in the app.

#### A. Save to a database

Here's an example of how you could save the generated text into a database (e.g., SQLite)

```dart
// Function to save styled text to a database
Future<void> _saveToDatabase(String styledText) async {
  await DatabaseHelper.instance.insertStyledText(styledText); // Your database logic here
}

// Styled Text Editor
StyledTextEditor(
  controller: _textController,
  onTextChange: (result) {
    setState(() {
      _finalStyledText = result;
    });
  },
);

// Save when user clicks the button
ElevatedButton(
  onPressed: () {
    _saveToDatabase(_finalStyledText);  // Save the styled text to the database
  },
  child: Text('Save Styled Text'),
);
```

#### B. Directly use from the variable:

You can also use the `_finalStyledText` directly from the variable without saving it to a database if you want to display or process it immediately using the `StyledTextPreview` widget to render it.

```dart
// Preview the styled text
StyledTextPreview(
  text: _finalStyledText,  // Display the styled text
  fontColor: Colors.black,
  fontSize: 16,
);
```

### 4. Retrieving and previewing the styled text

When you need to display the styled text, retrieve the stored text from the database and use the StyledTextPreview widget to render it

## Full Example

The `StyledTextEditor` allows you to input styled text, and it outputs the final styled result in a markdown-like syntax. This final result can be stored in a database or any persistent storage.

```dart
String _retrievedStyledText = ''; // Retrieved styled text from database

// Function to retrieve styled text from database
Future<void> _getFromDatabase() async {
  String result = await DatabaseHelper.instance.getStyledText();  // Database retrieval logic
  setState(() {
    _retrievedStyledText = result;
  });
}

// Preview the styled text
StyledTextPreview(
  text: _retrievedStyledText,  // Display the styled text
  fontColor: Colors.black,
  fontSize: 16,
);
```

```dart
import 'package:flutter/material.dart';
import 'package:flutter_styling_text_editor/flutter_styling_text_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Styling Text Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _textController =
      TextEditingController(); // Controller for the text editor
  String _finalStyledText = ''; // This will hold the final styled text

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: StyledTextEditor(
              controller: _textController, // Controller for text input
              backgroundColor:Colors.grey[300], // Background color of the editor
              boarderRadius: 10, // Border radius for the full StyledTextEditor
              textEditorColor: Colors.white, // Color of the StyledTextEditor
              textColor: Colors.black, // Text color inside the editor
              fontSize: 16, // Font size for text
              fontFamily: '', // Font family (empty uses default)
              onTextChange: (result) {
                setState(() {
                  _finalStyledText = result; // Update the styled text when the user types
                });
              },
            ),
          ),

          // Displaying the styled text in a preview widget
          StyledTextPreview(
            text: _finalStyledText, // The styled text to be shown
            fontColor: Colors.black, // Font color for the preview
            fontFamily: '', // Font family for the preview
            fontSize: 16, // Font size for the preview
          ),
        ],
      ),
    );
  }
}
```


### Use Cases

- **Admin Panels**: Admins can input styled text using the `StyledTextEditor` and save it to the backend. Later, this styled text can be displayed on the client side using `StyledTextPreview`.

- **Content Management Systems (CMS)**: This package can be useful for any app where rich text editing and formatted text previewing are needed, such as blogs, news platforms, or educational apps.



