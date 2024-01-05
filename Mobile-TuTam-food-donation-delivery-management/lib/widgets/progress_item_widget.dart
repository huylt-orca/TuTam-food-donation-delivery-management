import 'package:flutter/material.dart';

import 'progress_bar_widget.dart';

class ProgressItemWidget extends StatelessWidget {
  final int index;
  final String itemName;
  final String itemAim;
  final String itemCurrent;
  final double percent;

  const ProgressItemWidget({
    super.key,
    required this.index,
    required this.itemName,
    required this.itemAim,
    required this.itemCurrent,
    required this.percent
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$index. $itemName (Mục tiêu: $itemAim)'),
          ProgressBarWidget(percent: percent),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Đã đạt được $itemCurrent',
        style: const TextStyle(
          fontSize: 12
        ),
        ),
        Text('$percent%',
        style: const TextStyle(
          fontSize: 12
        ),
        ),
      ],
    ),
        ],
      ),
    );
  }
}