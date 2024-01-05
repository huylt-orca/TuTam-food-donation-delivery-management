import 'package:flutter/material.dart';

class DonatedRequestUtils {
  static String textStatus(String value) {
    switch (value) {
      case 'PENDING':
        return 'Đang chờ';
      case 'ACCEPTED':
        return 'Chấp nhận';
      case 'REJECTED':
        return 'Từ chối';
      case 'CANCELED':
        return 'Bị hủy';
      case 'EXPIRED':
        return 'Hết hạn';
      case 'PROCESSING':
        return 'Đang xử lý';
      case 'SELF_SHIPPING':
        return 'Tự giao hàng';
      case 'REPORTED':
        return 'Báo cáo';
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
      case 'REJECTED':
        return Colors.red;
      case 'CANCELED':
        return Colors.orange;
      case 'EXPIRED':
        return Colors.grey;
      case 'PROCESSING':
        return Colors.yellow;
      case 'SELF_SHIPPING':
        return Colors.purple;
      case 'REPORTED':
        return Colors.red.shade700;
      case 'FINISHED':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
