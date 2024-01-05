import 'dart:convert';

import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;

class ActivityFeedbackService {
  static const String url = "${AppConfig.SERVER}activity-feedbacks";

  static Future<bool> sendFeedbackToActivity (
    {
      required String activityId, 
      required String content,
      required int rating}) async{
   
    var body = jsonEncode({
      'activityId': activityId,
      'content': content,
      'rating': rating
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      var response = await http.put(Uri.parse(url), body: body, headers: headers);

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

  static Future<bool> checkUserSendActivityFeedbackIsSend(
      {required String activityId}) async {

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
      final response = await http.get(Uri.parse('$url/activity?activityId=$activityId'), headers: headers);
      print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data'] == null ? true :  data['data']['status'] == 'FEEDBACK_PROVIDED';
    } else {
      throw MyCustomException.fromObject(json.decode(response.body));
    }

    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

}