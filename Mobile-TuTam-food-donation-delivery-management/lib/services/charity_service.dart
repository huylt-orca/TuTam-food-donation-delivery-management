import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/charity.dart';
import 'package:food_donation_delivery_app/models/charity_unit.dart';
import 'package:food_donation_delivery_app/services/charity_unit_service.dart';
import 'package:http/http.dart' as http;
class CharityService {
  static const String url = "${AppConfig.SERVER}charities";

   static List<Charity> parserCharityList(String responseBody){
    var data = json.decode(responseBody) ;
    var list = data['data'] as List<dynamic>;
    List<Charity> charities = list.map((model) => Charity.fromJson(model)).toList();
    return charities;
  }

  static Future<List<Charity>> fetchCharitiesList({
    String name = '',
    int status = -1,
    int page = 1,
    int pageSize = 21,
    String orderBy = '',
    int sortType = -1
  }) async{
    

    String options =
        "?pageSize=$pageSize"
        "&page=$page"
    ;

    if (name.isNotEmpty){
      options += '&name=$name';
    }

    if (status != -1){
      options += '&charityStatus=$status';
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
      // 'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse(url + options),headers: headers );
    if (response.statusCode ==200){
      return compute(parserCharityList,response.body);
    } else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
    
  }

  static Future<List<CharityUnit>> fetchCharityUnitsListByCharityId({
    required String charityId,
  }) async{
    
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse('$url/$charityId/charity-units'),headers: headers );
    if (response.statusCode ==200){
      return compute(CharityUnitService.parserCharityList,response.body);
    }  else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

   
}