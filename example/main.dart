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
