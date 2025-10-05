import 'package:flutter/material.dart';
import 'package:code_highlight_view/code_highlight_view.dart';
import 'package:code_highlight_view/themes/github.dart';
import 'package:vote_explorer/core/dummy/dummy_block_json.dart';
import 'package:vote_explorer/style/text_style.dart';

class JSONHighlightView extends StatelessWidget {
  const JSONHighlightView({super.key});

  @override
  Widget build(BuildContext context) {
    return CodeHighlightView(
      dummyBlockJSON,
      language: 'json',
      isSelectable: true,
      theme: githubTheme,
      padding: EdgeInsets.all(12),
      textStyle: AppTextStyle.json,
    );
  }
}
