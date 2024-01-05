import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/controllers/user_controller.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:food_donation_delivery_app/screens/account/login_screen.dart';
import 'package:food_donation_delivery_app/screens/bottom_bar.dart';
import 'package:food_donation_delivery_app/screens/profile/update_profile_screen.dart';
import 'package:food_donation_delivery_app/services/auth_service.dart';
import 'package:food_donation_delivery_app/services/user_service.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();
  final UserController _userController = Get.find();

  void fetchData() async {
    
    bool isRemember = await StorageRepository.getIsRemember() ?? false;
    String phone = await StorageRepository.getPhone() ?? '';
    String password = await StorageRepository.getPassword() ?? '';
    try {
      if (!context.mounted) return;
    if (isRemember && phone != '' && password != '') {
      bool isSuccess = await _authService.loginWithPhone(phone, password);
      
      if (isSuccess) {
        // UserService.updateDeviceToken();
        // await UserService.getUserProfile();
        await UserService.settingForUser();
        if (!context.mounted) return;
        if (_userController.address.value.isEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const UpdateProfileScreen(isFirst: true,),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomBar(),
            ),
          );
        }
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }

    }
    catch(e){
      Fluttertoast.showToast(
        msg: e.toString(),
        gravity: ToastGravity.CENTER
        );
        if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: 
      Stack(
        children: [
          Image(
            image: const AssetImage('assets/myassets/onboarding_screen.png'),
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
          ),
          Positioned(
            left: 0,
            right: 0,
            top:  MediaQuery.of(context).size.height * 0.1,
            child: const Center(child: Column(
              children: [
                Text(AppConfig.TITLE,
                 style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
              'Tổ chức từ thiện',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),
            )
              ],
            ))
            ),
            Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.1,
            child: const Center(child: 
            CircularProgressIndicator(
              color: Colors.white,
            )
            // ShaderMask(
            //    shaderCallback: (bounds) {
            //   return const LinearGradient(
            //     colors: [Colors.blue, Colors.red],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ).createShader(bounds);
            // },
            //   child: const Text(
            //     'Từ Tâm Never Die',
            //     style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 40,
            //           fontWeight: FontWeight.bold,
                      
            //         ),
            //   ),
            // ),
            ),
            )
        ],
      ),
    );
  }
}
