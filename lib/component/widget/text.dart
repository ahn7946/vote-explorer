import 'package:flutter/material.dart';
import 'package:vote_explorer/style/text_style.dart';

SizedBox buildEllipsedText(String text, double width) {
  return SizedBox(
    width: width,
    child: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.fade,
      softWrap: false,
      style: AppTextStyle.tableTuple,
    ),
  );
}
