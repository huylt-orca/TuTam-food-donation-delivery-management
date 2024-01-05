import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/item_template_list.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;
class ItemTemplateService {
  static const String url = "${AppConfig.SERVER}item-templates";

  static List<ItemTemplateList> parserItemTemplatesList(String responseBody){
    var data = json.decode(responseBody) ;
    var list = data['data'] as List<dynamic>;
    List<ItemTemplateList> items = list.map((model) => ItemTemplateList.fromJson(model)).toList();
    return items;
  }

  static Future<List<ItemTemplateList>> fetchItemTemplatesList({
    String name = '',
    int page = 1,
    int pageSize = 10,
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
      return compute(parserItemTemplatesList,response.body);
    } else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<ItemTemplateList> fetchItemTemplateDetail( String itemsTemplateId  ) async{
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse("$url/$itemsTemplateId"),headers: headers);
    if (response.statusCode ==200){
      
      var data = json.decode(response.body)['data'];
      
      ItemTemplateList item = ItemTemplateList.fromJson(data);
    
      return item;
    } else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

}