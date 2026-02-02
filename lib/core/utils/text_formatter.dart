import 'package:flutter/material.dart';

/// Utility class to format text with markdown-style syntax
/// Converts **bold**, *italic* to proper TextSpan formatting
class TextFormatter {
  /// Converts markdown-style text to TextSpan with proper formatting
  static TextSpan formatText(String text, TextStyle baseStyle) {
    final List<TextSpan> spans = [];
    final RegExp pattern = RegExp(r'\*\*(.*?)\*\*|\*(.*?)\*');
    int lastIndex = 0;

    // Ensure baseStyle has line spacing
    baseStyle = baseStyle.copyWith(height: 1.6); // 1.6 = 60% extra line height

    for (final Match match in pattern.allMatches(text)) {
      // Add text before the match
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: baseStyle,
          ),
        );
      }

      // Add formatted text
      if (match.group(1) != null) {
        // Bold text (**text**)
        spans.add(
          TextSpan(
            text: match.group(1),
            style: baseStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        );
      } else if (match.group(2) != null) {
        // Italic text (*text*)
        spans.add(
          TextSpan(
            text: match.group(2),
            style: baseStyle.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      }

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex), style: baseStyle));
    }

    return TextSpan(children: spans);
  }

  /// Creates a RichText widget with formatted content
  static Widget createFormattedText(String text, TextStyle baseStyle) {
    return RichText(
      text: formatText(text, baseStyle),
      textAlign: TextAlign.start,
    );
  }
}
