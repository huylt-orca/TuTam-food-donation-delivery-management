import 'dart:convert';

import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;
class ActivityMemberService {
  static const String url = "${AppConfig.SERVER}activity-members";

  static Future<bool> sendApplicationToActivity (
    {
      required String activityId, 
      required String roleId,
      required String description}) async{
   
    var body = jsonEncode({
      'activityId': activityId,
      'description': description,
      'roleMemberId': roleId
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      var response = await http.post(Uri.parse(url), body: body, headers: headers);

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

  static Future<bool> checkUserSendActivityApplication(
      {required String activityId}) async {

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {

    
    final response = await http.get(Uri.parse('$url/$activityId/activity-member'), headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data'] as bool;
    } else {
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

}