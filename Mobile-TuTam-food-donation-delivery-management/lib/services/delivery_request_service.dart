import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/delivery_request_detail_user.dart';
import 'package:food_donation_delivery_app/models/schedule_route_detail.dart';
import 'package:food_donation_delivery_app/models/schedule_route_list.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;

class DeliveryRequestService{
   static const String url = "${AppConfig.SERVER}delivery-requests";

  static List<ScheduleRouteList> parseDeliveryRequestList(String responseBody){
    var data = json.decode(responseBody) ;
    var list = data['data'] as List<dynamic>;
    List<ScheduleRouteList> scheduleRoutes = list.map((model) => ScheduleRouteList.fromJson(model)).toList();
    return scheduleRoutes;
  }

  static Future<List<ScheduleRouteList>> fetchDeliveryRequestList({
    String latitude = '',
    String longitude = '',
    String branchId = '',
    int stockUpdatedHistoryType = -1, 
    int status = -1,
    String startDate = '',
    String endDate = '',
    int sortType = -1,
  }) async{
    
    String options ="/volunteer?";

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
    if (response.statusCode ==200){
      return compute(parseDeliveryRequestList,response.body);
    }  else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<DeliveryRequestDetailUser> fetchDeliveryRequestDetail({ 
    required String idDeliveryRequest}) async{
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {

    final response = await http.get(Uri.parse("$url/$idDeliveryRequest"),headers: headers);
    if (response.statusCode ==200){
      
      var data = json.decode(response.body)['data'];
      
      DeliveryRequestDetailUser deliveryRequest = DeliveryRequestDetailUser.fromJson(data);
    
      return deliveryRequest;
    } else{
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

    final response = await http.get(Uri.parse("$url/$scheduledRouteId/volunteer"),headers: headers);
    if (response.statusCode ==200){
      
      var data = json.decode(response.body)['data'];
      
      ScheduleRouteDetail route = ScheduleRouteDetail.fromJson(data);
    
      return route;
    } else{
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
      required double longtitude}) async{
   

    var body = jsonEncode({
      'scheduledRouteId': scheduledRouteId,
      'latitude': latitude,
      'longtitude': longtitude
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
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  // Collaborator start scheduled route
  static Future<bool> startScheduledRoute (
    {
      required String scheduledRouteId, 
      required double latitude,
      required double longtitude}) async{
   

    var body = jsonEncode({
      'scheduledRouteId': scheduledRouteId,
      'latitude': latitude,
      'longtitude': longtitude
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
       throw MyCustomException.fromObject(json.decode(response.body));
      }
   } catch(error){
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

  static Future<bool> updateReceivedQuantity (
    {
      required String deliveryRequestId,
      required String imageUrl,
      required List<DeliveryItems> items
      }) async{
   
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
  
    var body = jsonEncode({
      'proofImage': imageUrl,
      'deliveryItemForUpdatings': items.map((e) {
         final data = <String, dynamic>{};
        data['deliveryItemId'] = e.deliveryItemId;
        data['quantity'] = e.receivedQuantity;
        return data;
      }).toList(),
    });

    try {
      var response = await http.put(Uri.parse('$url/$deliveryRequestId/delivery-items'), headers: headers, body: body);
   
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

  static Future<bool> reportDeliveryRequest(
    {
      required String deliveryRequestId,
      required String title,
      required String content,
      required int type
      }) async{
   
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    var body = jsonEncode({
      'title': title,
      'content': content,
      'type': type
    });
    try {
      var response = await http.post(Uri.parse('$url/$deliveryRequestId/reports/contributor'), headers: headers, body: body);
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


  static Future<bool> updateNextStatusDeliveryRequest(
    {
      required String deliveryRequestId,
      }) async{
   
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      var response = await http.put(Uri.parse('$url/$deliveryRequestId'), headers: headers);
      
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

   static Future<bool> sendReportForDeliveryRequestFromUser(
    {
      required String deliveryRequestId,
      required String title,
      required String content
      }) async{
   
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    var body = jsonEncode({
      'title': title,
      'content': content,
    });

    try {
      var response = await http.post(Uri.parse('$url/$deliveryRequestId/reports'), headers: headers, body: body);
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

   static Future<bool> updateProofImageForUnit(
    {
      required String deliveryRequestId,
      required String proofImage,
      }) async{
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    var body = jsonEncode({
      'link': proofImage,
    });

    try {
      var response = await http.put(Uri.parse('$url/$deliveryRequestId/proof-image'), headers: headers, body: body);
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