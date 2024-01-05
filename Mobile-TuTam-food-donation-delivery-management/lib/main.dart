import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/app_theme.dart';
import 'package:food_donation_delivery_app/controllers/list_permission_controller.dart';
import 'package:food_donation_delivery_app/controllers/notification_controller.dart';
import 'package:food_donation_delivery_app/controllers/schedule_route_controller.dart';
import 'package:food_donation_delivery_app/controllers/user_controller.dart';
import 'package:food_donation_delivery_app/screens/main/splash_screen.dart';
import 'package:food_donation_delivery_app/services/firebase_service.dart';
import 'package:food_donation_delivery_app/utils/for_ground_local_notification.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseService().initNotifications();

  // final signalRNotificationService = SignalRNotificationService();
  // await signalRNotificationService.startConnection();
  // signalRNotificationService.registerListeners();

  Get.put(UserController());
  Get.put(ScheduleRouteController());
  Get.put(NotificationController());
  Get.put(ListPermissionController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  

    ForGroundLocalNotification.initialize();
    // For Forground state;
    FirebaseMessaging.onMessage.listen((event) {
      Get.find<NotificationController>().changeNumber(1);
      ForGroundLocalNotification.showNotification(event);
    });
    return GetMaterialApp(
      title: AppConfig.NAME,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // scaffoldBackgroundColor: AppTheme.mainBackground,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: AppTheme.blackText,
            fontSize: 12
          ),
        ),
        // cardTheme: const CardTheme(
        //   color: Colors.white,
        //   // shadowColor: Colors.white
        // )
      ),
      // home: SafeArea(child: BottomBar(),) ,
      // home: BottomBar(),
      // home: TestScreen(),
      // home: LoginScreen(),
      home: const SplashScreen(),
    );
  }
}

