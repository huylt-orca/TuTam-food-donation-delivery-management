import 'package:flutter/material.dart';

class TextDeliveryCardWidget extends StatelessWidget {
  final String text;
  final String description;
  const TextDeliveryCardWidget({
    super.key,
    required this.description,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(description,
        style: TextStyle(
          color: Colors.grey[700]
        ),
        ),
        Text(text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey[800]
        ),
        )
      ],
    );
  }
}