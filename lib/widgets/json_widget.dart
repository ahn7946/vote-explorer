import 'package:flutter/material.dart';
import 'package:code_highlight_view/code_highlight_view.dart';
import 'package:code_highlight_view/themes/github.dart';
import 'package:vote_explorer/models/dummy_json.dart';

class JsonWidget extends StatelessWidget {
  const JsonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CodeHighlightView(
      dummy_json,
      language: 'json',
      isSelectable: true,
      theme: githubTheme,
      padding: EdgeInsets.all(12),
      textStyle: TextStyle(
        fontFamily: 'Jetbrains Mono',
        fontSize: 16,
      ),
    );
  }
}
