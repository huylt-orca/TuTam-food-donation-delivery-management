import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/models/notification_list.dart';
import 'package:food_donation_delivery_app/screens/activity/activity_detail_screen.dart';
import 'package:food_donation_delivery_app/screens/delivery_request/delivery_request_detail_screen.dart';
import 'package:food_donation_delivery_app/screens/donation/donated_request_detail_user_screen.dart';
import 'package:food_donation_delivery_app/screens/donation/history_delivery_request_detail_screen.dart';
import 'package:food_donation_delivery_app/utils/notification_type_utils.dart';
import 'package:food_donation_delivery_app/utils/utils.dart';

class NotificationCard extends StatelessWidget {
  final void Function() onTap;
  final NotificationList notification;
  const NotificationCard(
      {super.key, required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        
        switch (notification.dataType) {
          case 'DELIVERY_REQUEST':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeliveryRequestDetailScreen(
                  idDeliveryRequest: notification.dataId,
                  isRunning: false,
                ),
              ),
            );
            break;
          case 'DONATED_REQUEST':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DonatedRequestDetailUserScreen(
                  idDonatedRequest: notification.dataId,
                ),
              ),
            );
            break;
          case 'ACTIVITY':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetailScreen(
                  idActivity: notification.dataId,
                ),
              ),
            );
            break;
            case 'REPORTABLE_DELIVERY_REQUEST':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryDeliveryRequestDetailScreen(
                  idDeliveryRequest: notification.dataId,
                ),
              ),
            );
            break;
          default:
            break;
        }
      },
      child: Container(
        color: notification.status == 'NEW' ? Colors.blue[50] : Colors.white,
        child: ListTile(
          leading: SizedBox(
              height: 70,
              width: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  notification.image,
                  fit: BoxFit.contain,
                ),
              ),),
              // CircleAvatar(
              //     backgroundImage: NetworkImage(notification.image))),
          title: Text(
            notification.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.content),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            '● ${NotificationTypeUtils.textStatus(notification.type)} ',
                        style: TextStyle(
                            color: NotificationTypeUtils.colorStatus(
                                notification.type))),
                    TextSpan(
                      text:
                          '● ${Utils.convertDateToTimeDateVN(notification.createdDate)}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          isThreeLine: false,
        ),
      ),
    );
  }
}
