import 'package:flutter/material.dart';

/// A customizable text editor widget that allows styling text with various attributes like bold, italic, and underline.
///
/// The [StyledTextEditor] widget provides a text field where the user can input text and apply styles to it.
class StyledTextEditor extends StatefulWidget {
  /// The [TextEditingController] used to control the input text field.
  final TextEditingController controller;

  /// A callback function that is triggered when the text content changes.
  final ValueChanged<String> onTextChange;

  /// The background color of the text editor widget.
  /// Defaults to `Colors.grey[300]` if not specified.
  final Color? backgroundColor;

  /// The border radius of the text editor's container.
  /// Defaults to `10` if not specified.
  final double? boarderRadius;

  /// The background color of the text area where text is displayed.
  final Color? textEditorColor;

  /// The color of the text within the editor.
  final Color? textColor;

  /// The font family used in the text editor.
  final String? fontFamily;

  /// The font size used for the text in the editor.
  final double? fontSize;

  /// The [StyledTextEditor] widget provides a text field where the user can input text and apply styles to it.
  const StyledTextEditor({
    super.key,
    required this.controller,
    required this.onTextChange,
    this.backgroundColor,
    this.boarderRadius,
    this.textEditorColor,
    this.textColor,
    this.fontFamily,
    this.fontSize,
  });

  @override
  State<StyledTextEditor> createState() => _StyledTextEditorState();
}

class _StyledTextEditorState extends State<StyledTextEditor> {
  final Set<String> _activeStyles =
      {}; // Tracks active styles (bold, italic, underline)
  final List<StyledTextSegment> _textSegments =
      []; // List of styled text segments
  String _currentText = ''; // The current text from the controller
  String finalResult = ''; // The final result that combines all styled text

  /// Toggles the given text style between active and inactive states.
  void _toggleStyle(String style) {
    setState(() {
      if (_activeStyles.contains(style)) {
        _activeStyles.remove(style);
      } else {
        _activeStyles.add(style);
      }
    });
  }

  /// Handles changes in the text field and applies the active styles to the input text.
  void _onTextChanged() {
    setState(() {
      _currentText = widget.controller.text;
      if (_currentText.isNotEmpty) {
        // Format text based on active styles
        String styledText = _currentText;

        // Apply active styles to the text
        if (_activeStyles.contains('bold')) {
          styledText = '**$styledText**';
        }
        if (_activeStyles.contains('italic')) {
          styledText = '*$styledText*';
        }
        if (_activeStyles.contains('underline')) {
          styledText = '__${styledText}__';
        }

        // Add the new segment to text segments
        _textSegments
            .add(StyledTextSegment(_currentText, _activeStyles.toList()));

        // Update finalResult with the new styled segment
        finalResult += styledText; // Add space for separation

        widget.controller.clear();

        // Trigger the callback to pass the final result
        widget.onTextChange(finalResult);
      }
    });
  }

  /// Deletes the last segment of styled text from the editor.
  void _deleteLastSegment() {
    setState(() {
      if (_textSegments.isNotEmpty) {
        final deletedSegment = _textSegments.removeLast();
        final deletedStyledText = formatStyledText(deletedSegment);
        finalResult = finalResult.replaceFirst('$deletedStyledText ', '');
      }
    });
  }

  /// Clears all the text and style segments in the editor.
  void _clearAllText() {
    setState(() {
      _textSegments.clear();
      finalResult = ''; // Clear finalResult as well
    });
  }

  /// Formats the given [StyledTextSegment] into a styled string.
  String formatStyledText(StyledTextSegment segment) {
    String styledText = segment.text;
    if (segment.styles.contains('bold')) {
      styledText = '**$styledText**';
    }
    if (segment.styles.contains('italic')) {
      styledText = '*$styledText*';
    }
    if (segment.styles.contains('underline')) {
      styledText = '__${styledText}__';
    }
    return styledText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(widget.boarderRadius ?? 10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Styled Text Output
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: widget.textEditorColor ?? Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: widget.textColor ?? Colors.black,
                      fontSize: widget.fontSize ?? 16,
                      fontFamily: widget.fontFamily ?? ''),
                  children: _buildTextSpans(_textSegments),
                ),
              ),
            ),

            // Text Input Field
            TextField(
              controller: widget.controller,
              onChanged: (text) {
                _onTextChanged();
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintText: '',
                fillColor: widget.textEditorColor ?? Colors.white,
                filled: true,
                suffixIcon: IconButton(
                  onPressed: _deleteLastSegment,
                  icon: Icon(
                    Icons.backspace_outlined,
                    color: widget.textColor ?? Colors.black,
                  ),
                ),
              ),
              cursorColor: widget.textColor ?? Colors.black,
            ),
            const SizedBox(height: 20),
            // Styling Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _toggleStyle('bold'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            color: _activeStyles.contains('bold')
                                ? Colors.blue.shade800
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.format_bold,
                            color: _activeStyles.contains('bold')
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click, // For the web use
                      child: GestureDetector(
                        onTap: () => _toggleStyle('italic'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            color: _activeStyles.contains('italic')
                                ? Colors.blue.shade800
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.format_italic,
                            color: _activeStyles.contains('italic')
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _toggleStyle('underline'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                            color: _activeStyles.contains('underline')
                                ? Colors.blue.shade800
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.format_underline,
                            color: _activeStyles.contains('underline')
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _clearAllText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds a list of [TextSpan] widgets from a list of [StyledTextSegment].
///
/// Each segment contains text with associated styles, such as bold, italic, or underline.
List<TextSpan> _buildTextSpans(List<StyledTextSegment> segments) {
  List<TextSpan> textSpans = [];

  for (var segment in segments) {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight:
          segment.styles.contains('bold') ? FontWeight.bold : FontWeight.normal,
      fontStyle: segment.styles.contains('italic')
          ? FontStyle.italic
          : FontStyle.normal,
      decoration: segment.styles.contains('underline')
          ? TextDecoration.underline
          : TextDecoration.none,
    );

    textSpans.add(TextSpan(text: segment.text, style: textStyle));
  }

  return textSpans;
}

/// A class representing a segment of text with associated styles (bold, italic, underline).
class StyledTextSegment {
  /// [text] is the content of the text segment
  final String text;

  ///  [styles] is a list of styles applied to that text.
  final List<String> styles;

  /// Creates an instance of [StyledTextSegment] with the given [text] and [styles].
  StyledTextSegment(this.text, this.styles);
}
