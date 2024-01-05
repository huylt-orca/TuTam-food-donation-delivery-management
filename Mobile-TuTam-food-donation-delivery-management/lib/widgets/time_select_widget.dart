import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';

class TimeSelectWidget extends StatelessWidget {
  final String txtDate;
  final String txtHour;
  final Color background;
  final Color textColor;
  const TimeSelectWidget({
    super.key,
    required this.txtDate,
    required this.txtHour,
    this.background = AppTheme.greyBackground,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 120,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
         color: background,
        borderRadius: const BorderRadius.all(Radius.circular(4.0))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(txtDate,
          style: TextStyle(
            color: textColor
          ),
          ),
          Text(txtHour == ' - ' ? 'Chọn thời gian' : txtHour,
          style: TextStyle(
            fontSize: 10,
             color: textColor,
          ),
          ),
        ],
      ),
    );
  }
}