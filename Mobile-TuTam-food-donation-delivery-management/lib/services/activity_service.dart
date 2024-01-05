import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import "package:food_donation_delivery_app/models/activity.dart";
import 'package:food_donation_delivery_app/models/activity_detail.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;
class ActivityService {
  static const String url = "${AppConfig.SERVER}activities";

  static List<Activity> parserActivityList(String responseBody){
    var data = json.decode(responseBody) ;
    var list = data['data'] as List<dynamic>;
    List<Activity> activities = list.map((model) => Activity.fromJson(model)).toList();
    return activities;
  }

  static Future<List<Activity>> fetchActivitiesList({
    String name = '',
    int status = -1,
    int scope = 0,
    List<String> activityTypeIds = const [],
    String startDate = '',
    String endDate = '',
    bool? isJoined,
    String branchId = '',
    String charityUnitId = '',
    String address = '',
    int page = 1,
    int pageSize = 10,
    String orderBy = 'CreatedDate',
    int sortType = 1
  }) async{
    
    String options =
        "?pageSize=$pageSize"
        "&page=$page"
    ;

    if (name.isNotEmpty){
      options += '&name=$name';
    }

    if (status != -1){
      options += '&status=$status';
    }

    if (activityTypeIds.isNotEmpty){
      for (var element in activityTypeIds) {
        options += '&activityTypeIds=$element';
      }
    }

    if (startDate != ''){
      options += '&startDate=$startDate';
    }

    if (endDate != ''){
      options += '&endDate=$endDate';
    }

    if (isJoined != null){
      options += '&isJoined=$isJoined';
    }

    if (branchId != ''){
      options += '&branchId=$branchId';
    }

    if (charityUnitId != ''){
      options += '&charityUnitId=$charityUnitId';
    }

    if (address != ''){
      options += '&address=$address';
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
      return compute(parserActivityList,response.body);
    } else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch (error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<ActivityDetail> fetchActivityDetail({required String activityId }) async{
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      final response = await http.get(Uri.parse("$url/$activityId"),headers: headers);
    if (response.statusCode ==200){
      
      var data = json.decode(response.body)['data'];
      
      ActivityDetail activity = ActivityDetail.fromJson(data);
    
      return activity;
    } else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch (error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
    
  }

}