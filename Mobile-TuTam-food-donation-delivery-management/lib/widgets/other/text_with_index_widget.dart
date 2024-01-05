import 'package:flutter/material.dart';

class TextWithIndexWidget extends StatelessWidget {
  final int index;
  final String textBold;
  final String text;
  const TextWithIndexWidget({
    super.key,
    required this.index,
    this.textBold ='',
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black
          ),
          children: [
            TextSpan(text: '$index. '),
            TextSpan(text: textBold,
            style: const TextStyle(
              fontWeight: FontWeight.w500
            ),
            ),
            TextSpan(text: text),
          ]
        ),
      ),
    );
  }
}