import 'package:flutter/material.dart';

class ActivityUtils {
  static String textStatus(String value) {
    switch (value) {
      case 'NOT_STARTED':
        return 'Sắp mở';
      case 'STARTED':
        return 'Hoạt động';
      case 'ENDED':
        return 'Đã kết thúc';
      case 'INACTIVE':
        return 'Đã xóa';
      default:
        return 'Error';
    }
  }

  static Color colorStatus(String value) {
    switch (value) {
      case 'NOT_STARTED':
        return Colors.amber;
      case 'STARTED':
        return Colors.green;
      case 'ENDED':
        return Colors.red;
      case 'INACTIVE':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
