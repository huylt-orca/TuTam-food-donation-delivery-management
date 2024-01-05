import 'package:get/get.dart';

class NotificationController extends GetxController{
  RxInt number = 0.obs;

  void addNumber(int num){
    number = RxInt(num);
    update();
  }

  void changeNumber (int num){
    number += num;
    update();

  }
}