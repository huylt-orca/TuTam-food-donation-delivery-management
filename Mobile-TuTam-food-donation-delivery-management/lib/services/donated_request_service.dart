import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as diolib;
import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/logging.dart';
import 'package:food_donation_delivery_app/models/delivery_request_list_user.dart';
import 'package:food_donation_delivery_app/models/donated_request_detail.dart';
import 'package:food_donation_delivery_app/models/donated_request_list.dart';
import 'package:food_donation_delivery_app/models/item_list.dart';
import 'package:food_donation_delivery_app/models/scheduled_times_object.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;

class DonatedRequestService {
  static const String url = "${AppConfig.SERVER}donated-requests";
  static final log = logger;

  static List<DonatedRequestList> parserDonatedRequestList(
      String responseBody) {
    var data = json.decode(responseBody);
    var list = data['data'] as List<dynamic>;
    List<DonatedRequestList> donatedRequestList =
        list.map((model) => DonatedRequestList.fromJson(model)).toList(); 
    return donatedRequestList;
  }

  static Future<List<DonatedRequestList>> fetchDonatedRequestList(
      {int status = -1,
      String startDate = '',
      String endDate = '',
      String activityId = '',
      String branchId = '',
      String userId = '',
      int page = 1,
      int pageSize = 10,
      String orderBy = 'CreatedDate',
      int sortType = 1}) async {
        
    String options = "?pageSize=$pageSize"
        "&page=$page";

    if (status != -1) {
      options += '&status=$status';
    }

    if (startDate != '') {
      options += '&startDate=$startDate';
    }

    if (endDate != '') {
      options += '&endDate=$endDate';
    }

    if (activityId != '') {
      options += '&activityId=$activityId';
    }

    if (branchId != '') {
      options += '&branchId=$branchId';
    }

    if (userId != '') {
      options += '&userId=$userId';
    }

    if (orderBy != '') {
      options += '&orderBy=$orderBy';
    }

    if (sortType != -1) {
      options += '&sortType=$sortType';
    }

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
  try {
    final response = await http.get(Uri.parse(url + options), headers: headers);
    if (response.statusCode == 200) {
      return compute(parserDonatedRequestList, response.body);
    } else {
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<DonatedRequestDetail> fetchDonatedRequestDetail(
      {required String idDonatedRequest}) async {
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {

    final response = await http.get(Uri.parse("$url/$idDonatedRequest"), headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data']; 

      DonatedRequestDetail detail = DonatedRequestDetail.fromJson(data);

      return detail;
    }  else {
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<bool> createDonatedRequest({
    required List<File> images,
    required String? address,
    required double latitude,
    required double longitude,
    required List<ScheduledTimesObject> scheduledTime,
    required String note,
    String? activityId,
    required List<ItemList> items,
  }) async {
    final dio = diolib.Dio();
    final formData = diolib.FormData.fromMap({
      'Note': note,
      'Address': address,
      'Location': [latitude, longitude].map((e) => e).toList(),
      'ScheduledTimes':
          scheduledTime.map((e) => jsonEncode(e.toJson())).toList(),
      if (activityId != null) 'ActivityId': activityId,
      'DonatedItemRequests':
          items.map((e) => jsonEncode(e.toJsonForCreateDonated())).toList()
    });

    for (int i = 0; i < images.length; i++) {
      formData.files.add(MapEntry(
        'Images',
        await diolib.MultipartFile.fromFile(images[i].path),
      ));
    }

    try {
      final response = await dio.post(
        url,
        data: formData,
        options: diolib.Options(headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log.w('Error: ${response.statusCode}');
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

    static Future<List<DeliveryRequestListUser>> fetchDeliveryRequestListByIdDonated(
      {required String donatedRequestId ,
      int page = 1,
      int pageSize = 10,}) async {
        
    String options = "/$donatedRequestId/finished-delivery-requests?pageSize=$pageSize"
        "&page=$page";


    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {

    final response = await http.get(Uri.parse(url + options), headers: headers);

    if (response.statusCode == 200) {
      
      var data = json.decode(response.body);
    var list = data['data'] as List<dynamic>;
    List<DeliveryRequestListUser> lists =
        list.map((model) => DeliveryRequestListUser.fromJson(model)).toList();
    return lists;
    }  else {
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<bool> cancelDonatedRequest (
    {
      required String idDonatedRequest}) async{
   
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
      var response = await http.put(Uri.parse('$url/$idDonatedRequest'), headers: headers);
      
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
