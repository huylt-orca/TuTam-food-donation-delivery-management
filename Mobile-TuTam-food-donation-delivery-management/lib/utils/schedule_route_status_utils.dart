import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';

class ScheduleRouteStatusUtils {

  static List<String> list = ['PENDING','ACCEPTED','PROCESSING','FINISHED','CANCEL'];

  static String textStatus(String value) {
    switch (value) {
      case 'PENDING':
        return 'Đang chờ';
      case 'ACCEPTED':
        return 'Đã nhận';
      case 'PROCESSING':
        return 'Đang xử lý';
      case 'FINISHED':
        return 'Hoàn thành';
      case 'CANCEL':
        return 'Bị hủy';
      default:
        return 'Error';
    }
  }

  static String textStatusButton(String value) {
    switch (value) {
      case 'PENDING':
        return 'Chấp nhận';
      case 'ACCEPTED':
        return 'Bắt đầu';
      case 'PROCESSING':
        return 'Tiếp tục';
      case 'FINISHED':
        return 'Hoàn thành';
      case 'CANCEL':
        return 'Bị hủy';
      default:
        return 'Error';
    }
  }

  static Color colorStatus(String value) {
    switch (value) {
      case 'PENDING':
        return Colors.grey;
      case 'ACCEPTED':
        return Colors.green;
         case 'PROCESSING':
        return Colors.amber;
         case 'FINISHED':
        return Colors.blue;
         case 'CANCEL':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  static Color colorStatusButton(String value) {
    switch (value) {
      case 'PENDING':
        return Colors.green;
      case 'ACCEPTED':
        return AppTheme.primarySecond;
         case 'PROCESSING':
        return Colors.amber;
         case 'FINISHED':
        return Colors.blue;
         case 'CANCEL':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
