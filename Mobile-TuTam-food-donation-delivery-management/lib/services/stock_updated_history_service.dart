import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/statement_list.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;

class StockUpdatedHistoryService{
   static const String url = "${AppConfig.SERVER}stock-updated-history-details";

  static List<StatementList> parseStatementList(String responseBody){
    var data = json.decode(responseBody) ;
    var list = data['data'] == null ? [] : data['data'] as List<dynamic>;
    
    List<StatementList> statements = list.map((model) => StatementList.fromJson(model)).toList();
    return statements;
  }

  static Future<List<StatementList>> fetchStatementList({
    int page = 1,
    int pageSize = 20,
    String startDate = '',
    String endDate = '',
    required String id,
    int typeAPI = 0 // 0: Branch, 1: Charity, 2: Activity, 3: User
  }) async{
    
    String options = url;
    switch (typeAPI){
      case 0: 
        options += '/branch/$id';
        break;
      case 1: 
        options += '/charity-unit/$id';
        break;
      case 2: 
        options += '/activity/$id';
        break;
        case 3:
        options +='/user';
      default: 
        options += '/branch/$id';
    }
    options +=
        "?pageSize=$pageSize"
        "&page=$page"
    ;

    if (startDate != ''){
      options += '&startDate=$startDate';
    }

    if (endDate != ''){
      options += '&endDate=$endDate';
    }

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse(options),headers: headers);
    if (response.statusCode == 200){
      return compute(parseStatementList,response.body);
    }  else{
     throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }
}