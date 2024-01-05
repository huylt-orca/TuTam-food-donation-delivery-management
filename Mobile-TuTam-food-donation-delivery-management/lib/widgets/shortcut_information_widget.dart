import 'package:flutter/material.dart';

class ShortcutInformationWidget extends StatelessWidget {
  final VoidCallback onPress;
  final String text;
  final IconData icon;
  final Color color;

  const ShortcutInformationWidget(
      {super.key,
      required this.text,
      required this.icon,
      this.color = Colors.black87,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(10.0)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
          onPressed: onPress,
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
              ),
              Text(
                text,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
