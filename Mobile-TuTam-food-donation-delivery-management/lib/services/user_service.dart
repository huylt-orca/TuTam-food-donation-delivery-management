import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as diolib;
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/controllers/list_permission_controller.dart';
import 'package:food_donation_delivery_app/controllers/user_controller.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/logging.dart';
import 'package:food_donation_delivery_app/models/permission_user.dart';
import 'package:food_donation_delivery_app/models/user.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:food_donation_delivery_app/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String url = "${AppConfig.SERVER}users";
  static final log = logger;

  static Future<bool> registerStepOne(String name, String phone) async {
    var uri = Uri.parse(url);
    var body = jsonEncode({
      'phone': phone,
      'fullName': name,
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      var response = await http.post(uri, body: body, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch (error) {
       if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<String> registerStepTwo(String otp, String phone) async {
    var uri = Uri.parse('$url/phone/verification');
    var body = jsonEncode({
      'phone': phone,
      'otp': otp,
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      var response = await http.post(uri, body: body, headers: headers);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['data'];
      } else {
       throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch (error) {
       if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<bool> registerStepThree(String password, String verifyCode) async {
    var uri = Uri.parse('$url/password');
    var body = jsonEncode({
      'password': password,
      'verifyCode': verifyCode,
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      var response = await http.put(uri, body: body, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
         throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch (error) {
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<bool> resendOTP(String phone) async {
    var uri = Uri.parse('$url/otp');
    var body = jsonEncode({
      'phone': phone,
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      var response = await http.put(uri, body: body, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch (error) {
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<bool> changePassword(
    {required String oldPassword,
    required String newPassword
    }) async {
    var uri = Uri.parse('$url/profile/password');
    var body = jsonEncode({
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      var response = await http.put(uri, body: body, headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
       throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<void> getUserProfile() async {
    var uri = Uri.parse('$url/profile');
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        User user = User.fromJson(data);
        final UserController userController = Get.find();
        userController.addUser(user);
        StorageRepository.saveUserId(user.id);
      } else {
        throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<bool> putUser({
      required String name,
      required String address,
      File? image, 
      required double latitude, 
      required double longitude,
      String phone = ''
      }) async {
    final dio = diolib.Dio();
    String urltmp = "$url/profile";

    final formData = diolib.FormData.fromMap({
      'Name': name,
      'Address': address,
      'Location': [latitude, longitude].map((e) => e).toList(),
      if (image != null)
        'Avatar': await diolib.MultipartFile.fromFile(image.path,
            filename: 'image.jpg'),
      if (phone != '') 'Phone': phone
    });

    try {
      final response = await dio.put(
        urltmp,
        data: formData,
        options: diolib.Options(headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
        }),
      );

      if (response.statusCode == 200) {
        await getUserProfile();
        return true;
      } else {
        log.w('Error: ${response.data}');
      }
    } catch (e) {
      if (e is diolib.DioError) {
        if (e.response != null) {
          log.w('Error data: ${e.response!.data}');
          throw MyCustomException.fromObject(e.response!.data);

          // print('Error status code: ${e.response!.statusCode}');
          // print('Error data: ${e.response!.data}');
        } else {
          log.w('Error data: ${e.message}');

          // print('Error2: ${e.message}');
        }
      } else {
        log.w('Unexpected error: $e');
      }
    }
    return false;
  }

  static Future<List<PermissionUser>> getListPermissions() async {
    var uri = Uri.parse('$url/permissions');
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data['data'] as List<dynamic>;
        List<PermissionUser> permissions =
            list.map((model) => PermissionUser.fromJson(model)).toList();
            final ListPermissionController listPermissionController = Get.find();
            listPermissionController.addListPermission(permissions);
            
        return permissions;
      } else {
       throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<bool> updateDeviceToken() async {
    var uri = Uri.parse('$url/device-token');
    var body = jsonEncode({
      'deviceToken': await StorageRepository.getDeviceToken(),
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      var response = await http.put(uri, body: body, headers: headers);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<void> settingForUser()async {
    updateDeviceToken();
    await getUserProfile();
    // getListPermissions();
    await NotificationService.fetchNotificationList();
  }
}
