import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/charity_unit.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;
class CharityUnitService {
  static const String url = "${AppConfig.SERVER}charity-units";

   static List<CharityUnit> parserCharityList(String responseBody){
    var data = json.decode(responseBody) ;
    var list = data['data'] as List<dynamic>;
    List<CharityUnit> charities = list.map((model) => CharityUnit.fromJson(model)).toList();
    return charities;
  }

  static Future<List<CharityUnit>> fetchCharityUnitsList({
    String name = '',
    int status = 1,
    int page = 1,
    int pageSize = 21,
    String orderBy = '',
    int sortType = -1
  }) async{
    

    String options = '?charityStatus=$status';
    //     "?pageSize=$pageSize"
    //     "&page=$page"
    // ;

    if (name.isNotEmpty){
      options += '&name=$name';
    }

    // if (status != -1){
    //   options += '&charityStatus=$status';
    // }

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
      return compute(parserCharityList,response.body);
    }  else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<CharityUnit> fetchCharityUnitDetail(String idUnit) async{
    var uri = Uri.parse('$url/$idUnit');
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
       var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        CharityUnit unit = CharityUnit.fromJson(data);
        return unit;
        
      } else {
        throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

}