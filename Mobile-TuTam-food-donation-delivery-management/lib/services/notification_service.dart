import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/controllers/notification_controller.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/notification_list.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class NotificationService {
  static const String url = "${AppConfig.SERVER}notifications";

   static List<NotificationList> parserNotificationList(String responseBody){
    var data = json.decode(responseBody) ;
    var list = data['data']['notificationResponses'] as List<dynamic>;
    List<NotificationList> notifications = list.map((model) => NotificationList.fromJson(model)).toList();
    return notifications;
  }

  static Future<List<NotificationList>> fetchNotificationList({
    int status = -1,
    int page = 1,
    int pageSize = 20,
    String orderBy = '',
    int sortType = -1
  }) async{
    
    String options =
        "?pageSize=$pageSize"
        "&page=$page"
    ;

    if (status != -1){
      options += '&status=$status';
    }

    if (orderBy != ''){
      options += '&orderBy=$orderBy';
    }

    if (sortType != -1){
      options += '&sortType=$sortType';
    }

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse(url + options),headers: headers );
    if (response.statusCode ==200){
     final NotificationController notificationController = Get.find();
     var data = json.decode(response.body) ;
    notificationController.addNumber(data['data']['notSeen']);
      return compute(parserNotificationList,response.body);
    } else{
     throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<bool> changeStatusNotification(List<String> id) async{
      var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    var body = jsonEncode({
      'notificationIds': id,
      'status': 1
    });
    try {
      final response = await http.put(Uri.parse(url),headers: headers, body: body );
    if (response.statusCode ==200){
      return true;
    }  else {
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }
}