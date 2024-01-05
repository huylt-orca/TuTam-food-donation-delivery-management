import 'package:flutter/material.dart';

class TextInBranchWidget extends StatelessWidget {
  final String textBold;
  final String text;
  const TextInBranchWidget({
    super.key,
    required this.textBold,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(textBold, style: const TextStyle(fontWeight: FontWeight.w500),),
          Text(text)
      ]),
    );
  }
}