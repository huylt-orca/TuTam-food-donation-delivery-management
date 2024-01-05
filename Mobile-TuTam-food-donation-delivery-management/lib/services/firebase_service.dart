import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage message)async{
    // print('Title: ${message.notification?.title}');
    // print('Body: ${message.notification?.body}');
    // print('Payload: ${message.data}');
  }

  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    // print('Token: $fCMToken');
    StorageRepository.saveDeviceToken(fCMToken ?? '');
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}