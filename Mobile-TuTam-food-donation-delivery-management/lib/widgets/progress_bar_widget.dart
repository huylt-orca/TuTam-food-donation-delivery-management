import 'package:flutter/material.dart';

import '../app_theme.dart';

class ProgressBarWidget extends StatelessWidget {
  final double percent;
  final double height;

  const ProgressBarWidget({
    super.key,
    required this.percent,
    this.height = 5.0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0,bottom: 4.0),
      child: Stack(
        children: [
          Container(     
            height: height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5.0)
            ),
          ),
          Container(     
            height: height,
            width: (percent / 100) * MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppTheme.primarySecond,
              borderRadius: BorderRadius.circular(5.0)
            ),
          )
        ],
      ),
    );
  }
}