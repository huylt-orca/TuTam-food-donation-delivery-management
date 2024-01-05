import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ForGroundLocalNotification{
  static final FlutterLocalNotificationsPlugin _notiPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(){
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        'mipmap/ic_launcher'
      )
    );
    _notiPlugin.initialize(
      initializationSettings,onDidReceiveNotificationResponse: (NotificationResponse details){
        // print("onDidReceiveNotificationResponse");
        // print(details.payload);
        // print(details.payload != null);

    }
    );
  }


  static void showNotification(RemoteMessage message){
    const NotificationDetails notiDetails = NotificationDetails(
      android: AndroidNotificationDetails(
      // 'com.example.push_notification',
      // 'push_notification',
      'channel_id_whatever',
      'channel_name',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    _notiPlugin.show(
      DateTime.now().microsecond,
      message.notification!.title,
      message.notification!.body,
      notiDetails,
      payload: message.data.toString(),
    );
  }
}