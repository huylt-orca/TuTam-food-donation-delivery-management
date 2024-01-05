import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';

class DeliveryRequestUtils {
  static String textStatus(String value) {
    switch (value) {
      case 'PENDING':
        return 'Đang chờ';
      case 'ACCEPTED':
        return 'Chấp nhận';
      case 'SHIPPING':
        return 'Đang đến';
      case 'ARRIVED_PICKUP':
        return 'Đã đến';
        // return 'Đã đến điểm nhận';
      case 'REPORTED':
        return 'Báo cáo';
      case 'COLLECTED':
        return 'Đã lấy';
      case 'ARRIVED_DELIVERY':
        return 'Đã đến';
        // return 'Đã đến điểm giao';
      case 'DELIVERED':
        return 'Đã giao hàng';
      case 'FINISHED':
        return 'Hoàn thành';
      default:
        return 'Error';
    }
  }

  static Color colorStatus(String value) {
    switch (value) {
      case 'PENDING':
        return Colors.blue;
      case 'ACCEPTED':
        return Colors.green;
      case 'SHIPPING':
        return Colors.orange;
      case 'ARRIVED_PICKUP':
        return Colors.brown;
      case 'REPORTED':
        return Colors.red;
      case 'COLLECTED':
        return Colors.yellow;
      case 'ARRIVED_DELIVERY':
        return Colors.purple;
      case 'DELIVERED':
        return Colors.grey;
      case 'FINISHED':
        return AppTheme.primarySecond;
      default:
        return Colors.black;
    }
  }
}
