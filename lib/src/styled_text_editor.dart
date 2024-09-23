import 'package:flutter/material.dart';

class StyledTextEditor extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onTextChange;
  final Color? backgroundColor;
  final double? boarderRadius;
  final Color? textEditorColor;
  final Color? textColor;
  final String? fontFamily;
  final double? fontSize;
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
  final Set<String> _activeStyles = {};
  final List<StyledTextSegment> _textSegments = [];
  String _currentText = '';
  String finalResult = '';

  void _toggleStyle(String style) {
    setState(() {
      if (_activeStyles.contains(style)) {
        _activeStyles.remove(style);
      } else {
        _activeStyles.add(style);
      }
    });
  }

  void _onTextChanged() {
    setState(() {
      _currentText = widget.controller.text;
      if (_currentText.isNotEmpty) {
        // Format text based on active styles
        String styledText = _currentText;

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

  void _deleteLastSegment() {
    setState(() {
      if (_textSegments.isNotEmpty) {
        final deletedSegment = _textSegments.removeLast();
        final deletedStyledText = formatStyledText(deletedSegment);
        finalResult = finalResult.replaceFirst('$deletedStyledText ', '');
      }
    });
  }

  void _clearAllText() {
    setState(() {
      _textSegments.clear();
      finalResult = ''; // Clear finalResult as well
    });
  }

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

class StyledTextSegment {
  final String text;
  final List<String> styles;

  StyledTextSegment(this.text, this.styles);
}
