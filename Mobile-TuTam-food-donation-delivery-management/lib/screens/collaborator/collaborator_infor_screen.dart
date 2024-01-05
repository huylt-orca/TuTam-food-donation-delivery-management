import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/controllers/user_controller.dart';
import 'package:food_donation_delivery_app/data/statistic_collaborator.dart';
import 'package:food_donation_delivery_app/models/sampledata.dart';
import 'package:food_donation_delivery_app/screens/main/delivery_requests_screen.dart';
import 'package:food_donation_delivery_app/utils/dialog_helper.dart';
import 'package:food_donation_delivery_app/widgets/delivery_request/text_delivery_card_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CollaboratorInforScreen extends StatefulWidget {
  const CollaboratorInforScreen({super.key});

  @override
  State<CollaboratorInforScreen> createState() =>
      _CollaboratorInforScreenState();
}

class _CollaboratorInforScreenState extends State<CollaboratorInforScreen> {
  final List<StatisticCollaborator> _listStatisticCollaborator = StatisticCollaborator.list;
  final UserController _userController = Get.find();
  
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Hủy hỗ trợ vận chuyển'),
                          content: const Text(
                              'Bạn có đồng ý muốn hủy hỗ trợ vận chuyển không?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Đóng'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Đồng ý',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                )),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               ListTile(
                leading: const SizedBox(
                    height: 70,
                    width: 70,
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(SampleData.image))),
                title: Text(
                  _userController.name.value,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(_userController.phone.value),
                trailing: const Icon(
                  LineAwesomeIcons.angle_right,
                  size: 18.0,
                  color: Colors.black,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                height: 150,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: _listStatisticCollaborator.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: AppTheme.mainBackground,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _listStatisticCollaborator[index].name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextDeliveryCardWidget(
                                description: 'Đơn',
                                text: '${_listStatisticCollaborator[index].requests} đơn',
                              ),
                              TextDeliveryCardWidget(
                                description: 'Quãng đường',
                                text: '${_listStatisticCollaborator[index].distances} km',
                              ),
                              TextDeliveryCardWidget(
                                description: 'Thời gian',
                                text: '${_listStatisticCollaborator[index].times} phút',
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Xem chi tiết',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20,),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppTheme.primarySecond),
                  ),
                  onPressed: () async{
                    try {
                  DialogHelper.showLoading(context);
                  LocationPermission permission =
                      await Geolocator.requestPermission();

                  Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );
                  bool isLocationServiceEnabled =
                      await Geolocator.isLocationServiceEnabled();

                  if(!context.mounted) return;
                  DialogHelper.hideLoading(context);

                  if (isLocationServiceEnabled) {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DeliveryRequestsScreen()),
                    );
                  } else {

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Vui lòng bật GPS'),
                          content: const Text('Ứng dụng cần GPS để lấy tọa độ.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Đóng'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (e) {
                  DialogHelper.hideLoading(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Vui lòng cấp quyền truy cập vị trí'),
                        content: const Text(
                            'Ứng dụng cần quyền truy cập vị trí để lấy tọa độ.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Đóng'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Mở cài đặt'),
                            onPressed: () async {
                              await Geolocator.openAppSettings();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                  },
                  child: const Text('Các lịch trình gần đây',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
