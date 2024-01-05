import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/activity_task.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;

class ActivityTaskService {
  static const String url = "${AppConfig.SERVER}activity-tasks";

  static List<ActivityTask> parserActivityTaskList(String responseBody) {
    var data = json.decode(responseBody);
    if (data['data'] == null) return [];
    var list = data['data'] as List<dynamic>;
    List<ActivityTask> tasks =
        list.map((model) => ActivityTask.fromJson(model)).toList();
    return tasks;
  }

  static Future<List<ActivityTask>> fetchActivityTaskList(
      {required String activityId}) async {

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      final response = await http.get(Uri.parse('$url?activityId=$activityId'), headers: headers);
    if (response.statusCode == 200) {
      return compute(parserActivityTaskList, response.body);
    }  else {
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch (error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
    
  }

  
}
