import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/schedule_route_detail.dart';
import 'package:food_donation_delivery_app/models/schedule_route_list.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;

class ScheduleRouteService{
   static const String url = "${AppConfig.SERVER}scheduled-routes";

  static List<ScheduleRouteList> parseScheduleRouteList(String responseBody){
    var data = json.decode(responseBody) ;
    var list = data['data'] as List<dynamic>;
    
    List<ScheduleRouteList> scheduleRoutes = list.map((model) => ScheduleRouteList.fromJson(model)).toList();
    return scheduleRoutes;
  }

  static Future<List<ScheduleRouteList>> fetchScheduleRouteList({
    String latitude = '',
    String longitude = '',
    String branchId = '',
    int stockUpdatedHistoryType = -1, 
    int status = -1,
    String startDate = '',
    String endDate = '',
    int sortType = -1,
  }) async{
    
    String options ="/contributor?";

    if (latitude.isNotEmpty){
      options += '&latitude=$latitude&longitude=$longitude';
    }

    if (status != -1){
      options += '&status=$status';
    }

    if (startDate != ''){
      options += '&startDate=$startDate';
    }

    if (endDate != ''){
      options += '&endDate=$endDate';
    }

    if (branchId != ''){
      options += '&branchId=$branchId';
    }

    if (sortType != -1){
      options += '&status=$status';
    }

   

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse(url + options),headers: headers );
    if (response.statusCode == 200){
      return compute(parseScheduleRouteList,response.body);
    }  else{
     throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<ScheduleRouteDetail> fetchScheduleRouteDetail( String scheduledRouteId) async{
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse("$url/$scheduledRouteId/contributor"),headers: headers);
    if (response.statusCode ==200){
      
      var data = json.decode(response.body)['data'];
      
      ScheduleRouteDetail route = ScheduleRouteDetail.fromJson(data);
    
      return route;
    }  else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }


  // Collaborator accept scheduled route
  static Future<bool> accepteScheduledRoute (
    {
      required String scheduledRouteId, 
      required double latitude,
      required double longitude}) async{
   

    var body = jsonEncode({
      'scheduledRouteId': scheduledRouteId,
      'latitude': latitude,
      'longitude': longitude
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
        throw MyCustomException.fromObject(
          json.decode(response.body)
        );
      }
    } catch (error) {
      rethrow;
    }
  }

  // Collaborator start scheduled route
  static Future<bool> startScheduledRoute (
    {
      required String scheduledRouteId, 
      required double latitude,
      required double longitude}) async{
   

    var body = jsonEncode({
      'scheduledRouteId': scheduledRouteId,
      'latitude': latitude,
      'longitude': longitude
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      var response = await http.put(Uri.parse('$url/started-scheduled-route'), body: body, headers: headers);

      if (response.statusCode == 200) {
        return true;
        
      } else {
        throw MyCustomException.fromObject(
          json.decode(response.body)
        );
      }
    } catch (error) {
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  // Collaborator update all delivery of scheduled route
  static Future<bool> updateAllDeliveryInScheduledRoute (
    {
      required String scheduledRouteId}) async{
   
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      var response = await http.put(Uri.parse('$url/$scheduledRouteId/delivery-requests'), headers: headers);
      
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

    static Future<bool> cancelScheduledRoute (
    {
      required String scheduledRouteId}) async{
   
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      var response = await http.put(Uri.parse('$url/$scheduledRouteId'), headers: headers);
      
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
}