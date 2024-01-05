import 'package:flutter/material.dart';

class ScheduleRouteBulkyUtils {
  static String textStatus(String value) {
    switch (value) {
      case 'NOT_BULKY':
        return 'Bình thường';
      case 'BULKY':
        return 'Cồng kềnh';
        case 'VERY_BULKY':
        return 'Rất cồng kềnh';
      default:
        return 'Error';
    }
  }

  static Color colorStatus(String value) {
    switch (value) {
      case 'NOT_BULKY':
        return const Color(0xFF295298);
      case 'BULKY':
        return Colors.amber;
        case 'VERY_BULKY':
        return Colors.amber;
      default:
        return Colors.black;
    }
  }
}
