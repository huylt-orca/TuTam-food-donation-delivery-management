import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';

class ChipActivityFilterWidget extends StatelessWidget {
  final String text;
  final bool visible;
  final void Function() onDeleted;

  const ChipActivityFilterWidget({
    super.key,
    required this.text,
    required this.visible,
    required this.onDeleted
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Chip(
          label: Text(
            text,
            style: const TextStyle(color: AppTheme.primaryFirst),
          ),
          onDeleted: onDeleted,
          deleteIconColor: Colors.red,
          side: const BorderSide(color: AppTheme.primaryFirst),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}