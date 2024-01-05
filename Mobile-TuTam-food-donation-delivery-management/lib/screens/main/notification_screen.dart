import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/controllers/notification_controller.dart';
import 'package:food_donation_delivery_app/models/notification_list.dart';
import 'package:food_donation_delivery_app/services/notification_service.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';
import 'package:food_donation_delivery_app/widgets/notification/shimmer_notification_card.dart';
import 'package:get/get.dart';

import '../../widgets/notification/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationList> _notifications = List.empty(growable: true);
  List<NotificationList> _newNotifications = List.empty(growable: true);
  bool _isRefresh = false;
  bool _isLoading = true;
  final NotificationController _notificationController = Get.find();


  void _getData(){
    _newNotifications = [];
    _notifications = [];
    NotificationService.fetchNotificationList().then((data) {
      for (var element in data) {
        if (Utils.converDate(element.createdDate) ==
            Utils.converDate(DateTime.now().toString())) {
          _newNotifications.add(element);
        } else {
          _notifications.add(element);
        }
      }
      setState(() {
        _isLoading = false;
        _isRefresh = !_isRefresh;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Thông báo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                GestureDetector(
                  onTap: () async {
                    await NotificationService.changeStatusNotification([
                      ..._newNotifications,
                      ..._notifications
                    ].expand((e) => [e.id]).toList());
                    
                    for (var item in _newNotifications){
                      item.status = 'SEEN';
                    }
                     for (var item in _notifications){
                      item.status = 'SEEN';
                    }
                    _notificationController.addNumber(0);

                    setState(() {
                      _isRefresh = !_isRefresh;
                    });

                  },
                  child: const Text(
                    'Xem tất cả',
                    style: TextStyle(color: AppTheme.primarySecond),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.73,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Hôm nay',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _isLoading ? 2 : _newNotifications.length,
                      itemBuilder: (context, index) {
                        return _isLoading
                            ? const ShimmerNotificationCard()
                            : NotificationCard(
                                notification: _newNotifications[index],
                                onTap: () {
                                  if (_newNotifications[index].status ==
                                      'NEW') {
                                      _notificationController.changeNumber(-1);
                                    setState(() {
                                      _newNotifications[index].status = 'SEEN';
                                    });
                                    NotificationService
                                        .changeStatusNotification(
                                            [_newNotifications[index].id]);
                                  }
                                },
                              );
                      }),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Trước đó',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _isLoading ? 5 : _notifications.length,
                      itemBuilder: (context, index) {
                        return _isLoading
                            ? const ShimmerNotificationCard()
                            : NotificationCard(
                                notification: _notifications[index],
                                onTap: () {
                                  if (_notifications[index].status == 'NEW') {
                                      _notificationController.changeNumber(-1);
                                    setState(() {
                                      _notifications[index].status = 'SEEN';
                                    });
                                    NotificationService
                                        .changeStatusNotification(
                                            [_notifications[index].id]);
                                  }

                                },
                              );
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
