import 'package:flutter/material.dart';

import '../../widgets/other/text_with_index_widget.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Điều khoản sử dụng'),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Chào mừng bạn đến với ứng dụng Từ Tâm. Trên hành trình thực hiện sứ mệnh chống lãng phí thực phẩm và hỗ trợ các tổ chức từ thiện khác' 
                    'trong việc cung cấp, hỗ trợ thực phẩm.'),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'GIẢI THÍCH KHÁI NIỆM',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextWithIndexWidget(
                  index: 1,
                  textBold: '"Ứng dụng Từ Tâm" ',
                  text:
                      'là ứng dụng công nghệ cung cấp các tiện ích và công cụ cho các cá nhân liên quan đến lĩnh vực tình nguyện, nhân đạo, từ thiện, hoạt động xã hội.',
                ),
                TextWithIndexWidget(
                  index: 2,
                  textBold: '"Người dùng" ',
                  text:
                      'là người tham gia vào hoạt động thiện nguyện cộng đồng trên nền tảng dưới các vai trò khác nhau như người cho đồ, tình nguyện viên, cộng tác viên, các tổ chức khác đăng ký vào hệ thống.',
                ),
                TextWithIndexWidget(
                  index: 3,
                  textBold: '"Người cho đồ" ',
                  text:
                      'là tất cả các cá nhân hoặc người đại diện có đồ dư và có mong muốn đem đi quyên góp thông qua ứng dụng và đồ sẽ được Từ Tâm nhận.',
                ),
                TextWithIndexWidget(
                  index: 4,
                  textBold: '"Tình nguyện viên" ',
                  text:
                      'là tất cả các cá nhân có mong muốn tham gia các hoạt động thiện nguyện thông của tổ chức.',
                ),
                TextWithIndexWidget(
                  index: 5,
                  textBold: '"Cộng tác viên" ',
                  text:
                      'là tất cả các cá nhân có mong muốn tham gia vào hệ thống của tổ chức với vai trò là người vận chuyển cho tổ chức',
                ),
                TextWithIndexWidget(
                  index: 6,
                  textBold: '"Tổ chức Từ Tâm" ',
                  text: 'là một tổ chức từ thiện hoạt động phi lợi nhuận với sứ mệnh chống lãng phí thực phẩm và hỗ trợ các tổ chức từ thiện khác' 
                      'trong việc cung cấp, hỗ trợ thực phẩm. Là tổ chức trung gian trong việc nhận đồ từ người cho, sau đó tập hợp lại và phân phát cho các tổ chức khác.',
                ),
                TextWithIndexWidget(
                  index: 7,
                  textBold: '"Các tổ chức khác" ',
                  text:
                      'là các tổ chức không thuộc về tổ chức Từ Tâm nhưng được Từ Tâm xác thực, họ tham gia vào hệ thống với vai trò nhận đồ từ Từ Tâm.',
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'NGUYÊN TÁC HOẠT ĐỘNG',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextWithIndexWidget(
                  index: 1,
                  text:
                      'Ứng dụng Từ Tâm là giải pháp nhằm ứng dụng công nghệ vào giải quyết vấn đề lãng phí thực phẩm của mọi người và các đồ dư thừa sẽ đến nơi thực sự cần và được dùng đúng với giá trị của nó.',
                ),
                TextWithIndexWidget(
                  index: 2,
                  text:
                      'Ứng dụng Từ Tâm là nền tảng nhân đạo hoạt động phi lợi nhuận và không thu bất kỳ chi phí từ người dùng.',
                ),
                TextWithIndexWidget(
                  index: 3,
                  text:
                      'Ứng dụng Từ Tâm hoạt động dựa trên tính minh bạch thông qua sự giám sát công khai cho cộng đồng và đảm bảo các đồ được quyên góp sẽ đến đúng nơi cần đến.',
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'CÁC HÀNH VI BỊ CẤM',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextWithIndexWidget(
                  index: 1,
                  textBold: 'Quảng cáo gian lận: ',
                  text:
                      'Không được sử dụng hoạt động thiện nguyện để thực hiện quảng cáo gian lận, lừa đảo hoặc thúc đẩy sản phẩm hoặc dịch vụ không đáng tin cậy hay để vụ lợi.',
                ),
                TextWithIndexWidget(
                  index: 2,
                  textBold: 'Kỳ thị và phân biệt đối xử: ',
                  text:
                      'Phải tôn trọng và đối xử bình đẳng với tất cả mọi người, không phân biệt dựa trên chủng tộc, tôn giáo, giới tính, hoặc bất kỳ yếu tố nào khác.',
                ),
                TextWithIndexWidget(
                  index: 3,
                  textBold: 'Tiêu cực hoặc gây hại: ',
                  text:
                      'Không được thực hiện hành động hoặc phát ngôn có thể gây hại hoặc làm tổn hại đến người khác hoặc cộng đồng.',
                ),
                TextWithIndexWidget(
                  index: 4,
                  textBold: 'Báo cáo thông tin sai lệch: ',
                  text:
                      'Khi bạn tham gia vào hoạt động thiện nguyện, bạn nên luôn cố gắng cung cấp thông tin chính xác và trung thực về hoạt động của bạn. Báo cáo sai lệch, bất trung thực hoặc gian lận về hoạt động của mình có thể dẫn đến sự mất niềm tin từ phía người khác và tổ chức bạn đang hợp tác.',
                ),
                TextWithIndexWidget(
                  index: 5,
                  textBold: 'Xâm phạm quyền riêng tư: ',
                  text:
                      'Không được xâm phạm quyền riêng tư của người khác khi tham gia hoạt động thiện nguyện. Điều này bao gồm việc thu thập thông tin cá nhân mà không có sự đồng ý của họ.',
                ),
                TextWithIndexWidget(
                  index: 6,
                  textBold: 'Lạm dụng quyền hành thông tin: ',
                  text:
                      'Không được sử dụng thông tin cá nhân của người khác một cách sai trái hoặc trái với quy định bảo vệ dữ liệu cá nhân.',
                ),
                TextWithIndexWidget(
                  index: 7,
                  textBold: 'Phân phối không đúng đắn: ',
                  text:
                      'Khi bạn tham gia phân phát hàng hóa hoặc dịch vụ cho cộng đồng, bạn nên đảm bảo rằng việc phân phối được thực hiện một cách công bằng và đúng đắn. Tránh việc ưu tiên phân phát cho những người quen hoặc có quan hệ cá nhân với bạn mà không tuân thủ tiêu chí xác định trước.',
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'QUY ĐINH KHÁC',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextWithIndexWidget(
                  index: 1,
                  textBold: 'Tên tài khoản: ',
                  text:
                      'Không dùng tên gây nhầm lẫn hay vi phạm quyền sở hữu trí tuệ. Tài khoản vi phạm sẽ bị xóa.',
                ),
                TextWithIndexWidget(
                  index: 2,
                  textBold: 'Hình ảnh: ',
                  text:
                      'Không dùng hình ảnh đồi trụy hoặc không phù hợp có hàm ý gây kích động. Tài khoản vi phạm sẽ bị xóa.',
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'BẢN QUYỀN',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text('............................................')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
