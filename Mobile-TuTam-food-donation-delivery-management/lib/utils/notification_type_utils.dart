import 'package:flutter/material.dart';

class NotificationTypeUtils {
  static String textStatus(String value) {
    switch (value) {
      case 'NOTIFYING':
        return 'Thông báo';
      case 'WARNING':
        return 'Cảnh báo';
      default:
        return 'Error';
    }
  }

  static Color colorStatus(String value) {
    switch (value) {
      case 'NOTIFYING':
        return Colors.green;
      case 'WARNING':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
