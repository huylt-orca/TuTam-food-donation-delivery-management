import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/activity_phase.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;

class ActivityPhaseService {
  static const String url = "${AppConfig.SERVER}phases";

  static List<ActivityPhase> parserActivityPhaseList(String responseBody) {
    var data = json.decode(responseBody);
    var list = data['data'] == null ? [] : data['data'] as List<dynamic>;
    List<ActivityPhase> phases =
        list.map((model) => ActivityPhase.fromJson(model)).toList();
    return phases;
  }

  static Future<List<ActivityPhase>> fetchActivityPhaseList(
      {required String activityId}) async {

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      final response = await http.get(Uri.parse('$url/activity/$activityId'), headers: headers);
    if (response.statusCode == 200) {
      return compute(parserActivityPhaseList, response.body);
    }  else {
     throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch (error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }
}
