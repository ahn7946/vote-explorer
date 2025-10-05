import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildCopyIconButton(context, text) {
  return IconButton(
    icon: const Icon(Icons.copy, size: 16, color: Colors.grey),
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(),
    tooltip: '클립보드에 복사하기',
    onPressed: () {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('클립보드에 복사 완료! : $text'),
          duration: const Duration(seconds: 1),
        ),
      );
    },
  );
}
