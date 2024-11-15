import 'package:flutter/material.dart';

class StyledTextPreview extends StatelessWidget {
  final String text;
  final Color? fontColor;
  final String? fontFamily;
  final double? fontSize;
  const StyledTextPreview({
    super.key,
    required this.text,
    this.fontColor,
    this.fontFamily,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    TextSpan parseStyledText(String text) {
      List<TextSpan> spans = [];
      final RegExp regex = RegExp(
        r'(\*\*\*[^*]+\*\*\*|\*\*[^*]+\*\*|\*[^\*]+\*|__[^_]+__|_[^_]+_|[^*_\s]+)',
        multiLine: true,
        dotAll: true,
      );

      final matches = regex.allMatches(text);
      for (var match in matches) {
        String matchedText = match.group(0)!; // Get the entire matched text
        TextStyle style = TextStyle(
            color: fontColor ?? Colors.black,
            fontFamily: fontFamily ?? '',
            fontSize: fontSize ?? 16);

        // Determine the appropriate style
        if (matchedText.startsWith('***') && matchedText.endsWith('***')) {
          style = TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: fontColor ?? Colors.black,
              fontFamily: fontFamily ?? '',
              fontSize: fontSize ?? 16);
          matchedText = matchedText.substring(3, matchedText.length - 3);
        } else if (matchedText.startsWith('__***') &&
            matchedText.endsWith('***__')) {
          style = TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              color: fontColor ?? Colors.black,
              fontFamily: fontFamily ?? '',
              fontSize: fontSize ?? 16);
          matchedText = matchedText.substring(5, matchedText.length - 5);
        } else if (matchedText.startsWith('__**') &&
            matchedText.endsWith('**__')) {
          style = TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              color: fontColor ?? Colors.black,
              fontFamily: fontFamily ?? '',
              fontSize: fontSize ?? 16);
          matchedText = matchedText.substring(4, matchedText.length - 4);
        } else if ((matchedText.startsWith('__*') &&
            matchedText.endsWith('*__'))) {
          style = TextStyle(
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.underline,
              color: fontColor ?? Colors.black,
              fontFamily: fontFamily ?? '',
              fontSize: fontSize ?? 16);
          matchedText = matchedText.substring(3, matchedText.length - 3);
        } else if (matchedText.startsWith('**') && matchedText.endsWith('**')) {
          style = TextStyle(
              fontWeight: FontWeight.bold,
              color: fontColor ?? Colors.black,
              fontFamily: fontFamily ?? '',
              fontSize: fontSize ?? 16);
          matchedText = matchedText.substring(2, matchedText.length - 2);
        } else if (matchedText.startsWith('*') && matchedText.endsWith('*')) {
          style = TextStyle(
              fontStyle: FontStyle.italic,
              color: fontColor ?? Colors.black,
              fontFamily: fontFamily ?? '',
              fontSize: fontSize ?? 16);
          matchedText = matchedText.substring(1, matchedText.length - 1);
        } else if (matchedText.startsWith('__') && matchedText.endsWith('__')) {
          style = TextStyle(
              decoration: TextDecoration.underline,
              color: fontColor ?? Colors.black,
              fontFamily: fontFamily ?? '',
              fontSize: fontSize ?? 16);
          matchedText = matchedText.substring(2, matchedText.length - 2);
        } else if (matchedText.startsWith('_') && matchedText.endsWith('_')) {
          style = TextStyle(
              decoration: TextDecoration.underline,
              color: fontColor ?? Colors.black,
              fontFamily: fontFamily ?? '',
              fontSize: fontSize ?? 16);
          matchedText = matchedText.substring(1, matchedText.length - 1);
        }

        // Add the styled text
        spans.add(TextSpan(text: matchedText, style: style));
      }

      // Add a space at the end of the last TextSpan only if spans are not empty
      if (spans.isNotEmpty) {
        spans.add(const TextSpan(text: ' '));
      }

      return TextSpan(children: spans);
    }

    return RichText(
      text: parseStyledText(
        text,
      ),
    );
  }
}
