import 'package:flutter/material.dart';

class ActivityTaskUtils {
  static String textStatus(String value) {
    switch (value) {
      case 'NOT_STARTED':
        return 'Chưa bắt đầu';
      case 'DONE':
        return 'Đã hoàn thành';
      case 'ACTIVE':
        return 'Đang tiến hành';
      default:
        return 'Error';
    }
  }

  static Color colorStatus(String value) {
    switch (value) {
      case 'NOT_STARTED':
        return Colors.amber;
      case 'DONE':
        return Colors.green;
      case 'ACTIVE':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
