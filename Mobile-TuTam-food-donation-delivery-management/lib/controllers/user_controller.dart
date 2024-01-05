import 'package:get/get.dart';

import '../models/user.dart';


class UserController extends GetxController{
  RxString id = "".obs;
  RxString name = "".obs;
  RxString avatar = "".obs;
  RxString address = "".obs;
  RxString location = "10.841186759826074, 106.8098541682659".obs;
  RxString phone = "".obs;
  RxString email = "".obs;
  RxBool collaboratorStatus = false.obs;
  

  void addUser(User user){
    id = RxString(user.id);
    name = RxString(user.name);
    avatar = RxString(user.avatar);
    address = RxString(user.address);
    location = RxString(user.location);
    phone = RxString(user.phone);
    email = RxString(user.email);
    collaboratorStatus = RxBool(user.collaboratorStatus);
  }
  
  void removeUser(){
    id = RxString("");
    name = RxString("");
    avatar = RxString("");
    address = RxString("");
    location = RxString("");
    phone = RxString("");
    email = RxString("");
    collaboratorStatus = RxBool(false);
  }


}