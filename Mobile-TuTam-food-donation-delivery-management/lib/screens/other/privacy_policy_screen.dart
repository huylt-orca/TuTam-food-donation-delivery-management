import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chính sách bảo mật'),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Cảm ơn bạn đã quan tâm và ủng hộ. Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn và tuân thủ các quy định về bảo mật dữ liệu. Chính sách bảo mật này sẽ mô tả cách chúng tôi thu nhập, sử dụng và bảo vệ thông tin cá nhân của bạn khi bạn dùng ứng dụng của chúng tôi.'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '1. Loại thông tin cá nhân chúng tôi thu nhập:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                    'Chúng tôi có thể thu nhập các thông tin cá nhân sau đây khi bạn dùng:'),
                Text(
                    '- Tên và thông tin liên hệ (địa chỉ emai, số điện thoại, địa chỉ nhà). \n - Thông tin về đồ bạn quyên góp'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '2. Mục đích sử dụng thông tin cá nhân:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text('Chúng tôi sử dụng các thông tin cá nhân của bạn để:'),
                Text(
                    '- Liên hệ và xác nhận quyên góp của bạn. \n - Quản lý và xử lý các đồ quyên góp. \n - Gửi các thông tin liên quan.'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '3. Bảo mật thông tin cá nhân:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                    'Chúng tôi đảm bảo rằng thông tin cá nhân của bạn được bảo mật và an toàn. Chúng tôi sẽ áp dụng biện pháp bảo mật và quản lý để ngăn chặn truy cập trái phép, sử dụng, tiết lộ hoặc hủy hoại thông tin cá nhân của bạn.'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '4. Chia sẻ thông tin cá nhân:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                    'Chúng tôi không chia sẻ thông tin cá nhân của bạn với bất kỳ bên thứ ba nào mà không có sự đồng thuận của bạn, trừ khi cần thiết để thực hiện và nghĩa vụ của chúng tôi theo luật pháp hoặc để xác nhận quyên góp của bạn.'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '5. Quyền của bạn:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                    'Bạn có quyền truy cập, chỉnh sửa hoặc xóa thông tin cá nhân của bạn khỏi hệ thống của chúng tôi.'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '6. Liên hệ:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                    'Nếu bạn có bất kỳ câu hỏi hoặc yêu cầu về chính sách bảo mật của chúng tôi, xin vui lòng liên hệ với chúng tôi.'),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'Chính sách Bảo mật này có thể được cập nhật và điều chỉnh theo thời gian. Xin vui lòng kiểm tra lại ứng dụng của chúng tôi để biết các thay đổi mới nhất.'),
                SizedBox(
                  height: 10,
                ),
                Text('Ngày có hiệu lực: 01-01-2024'),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
