import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/item_list.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;
class ItemService {
  static const String url = "${AppConfig.SERVER}item";

  static List<ItemList> parserItemsList(String responseBody){
    var data = json.decode(responseBody) ;
    var list = data['data'] as List<dynamic>;
    List<ItemList> items = list.map((model) => ItemList.fromJson(model)).toList();
    return items;
  }

  static Future<List<ItemList>> fetchItemsList({
    String searchKeyWord = '',
    int itemCategoryType = -1,
    String itemCategoryId = '',
    int pageSize = 10,
    int page = 1,
  }) async{

    String options =
        "?pageSize=$pageSize&page=$page"
    ;

    if (searchKeyWord.isNotEmpty){
      options += '&searchKeyWord=$searchKeyWord';
    }

    if (itemCategoryId.isNotEmpty){
      options += '&itemCategoryId=$itemCategoryId';
    }

    if (itemCategoryType != -1){
      options += '&itemCategoryType=$itemCategoryType';
    }

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse(url + options),headers: headers );
    if (response.statusCode ==200){
      return compute(parserItemsList,response.body);
    }  else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<ItemList> fetchItemDetail( String itemsId  ) async{
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {

    final response = await http.get(Uri.parse("$url/$itemsId"),headers: headers);
    if (response.statusCode ==200){
      
      var data = json.decode(response.body)['data'];
      
      ItemList item = ItemList.fromJson(data);
    
      return item;
    }  else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

}