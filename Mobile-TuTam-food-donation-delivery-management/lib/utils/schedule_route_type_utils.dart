import 'package:flutter/material.dart';

class ScheduleRouteTypeUtils {
  static String textStatus(String value) {
    switch (value) {
      case 'IMPORT':
        return 'Nhận hàng';
      case 'EXPORT':
        return 'Giao hàng';
      default:
        return 'Error';
    }
  }

  static Color colorStatus(String value) {
    switch (value) {
      case 'IMPORT':
        return const Color(0xFF295298);
      case 'EXPORT':
        return Colors.amber;
      default:
        return Colors.black;
    }
  }
}
