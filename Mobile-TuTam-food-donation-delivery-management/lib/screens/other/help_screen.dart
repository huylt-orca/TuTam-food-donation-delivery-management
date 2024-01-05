import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Liên hệ'),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TỔ CHỨC TỪ THIỆN TỪ TÂM',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'Địa chỉ: Lô E2a-7, Đường D1, Đ. D1, Long Thạnh Mỹ, Thành Phố Thủ Đức, Thành phố Hồ Chí Minh 700000, Việt Nam'),
                SizedBox(
                  height: 10,
                ),
                Text('Giấy phép hoạt động kinh doanh: chưa đăng ký'),
                SizedBox(
                  height: 10,
                ),
                Text('Giờ làm việc: rãnh thì làm'),
                SizedBox(
                  height: 10,
                ),
                Text('Hotline: 0123456789 (rãnh thì nghe)'),
                SizedBox(
                  height: 10,
                ),
                Text('Email: hotro@tutam.vn'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
