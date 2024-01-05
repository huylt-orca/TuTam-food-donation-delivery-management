import 'package:food_donation_delivery_app/models/permission_user.dart';
import 'package:get/get.dart';

class ListPermissionController extends GetxController {
  var permissions =  <PermissionUser>[];

  void addListPermission (List<PermissionUser> list){
    permissions = list;
  }

  bool hasPermittedPermission(String name) {
    return permissions.any(
      (p) => p.name == name && p.status == 'PERMITTED',
    );
  }
}