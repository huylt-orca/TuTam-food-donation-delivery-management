import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/branch.dart';
import 'package:food_donation_delivery_app/models/branch_detail.dart';
import 'package:http/http.dart' as http;

class BranchService {
  static const String url = "${AppConfig.SERVER}branches";

  static List<Branch> parserBranchList(String responseBody) {
    var data = json.decode(responseBody);
    var list = data['data'] as List<dynamic>;
    List<Branch> branches =
        list.map((model) => Branch.fromJson(model)).toList();
    return branches;
  }

  static Future<List<Branch>> fetchBranchesList(
      {String name = '',
      int status = -1,
      String address = '',
      int page = 1,
      int pageSize = 10,
      String orderBy = '',
      int sortType = -1}) async {

    String options = "?pageSize=$pageSize&page=$page";

    if (name.isNotEmpty) {
      options += '&name=$name';
    }

    if (status != -1) {
      options += '&status=$status';
    }

    if (address != '') {
      options += '&address=$address';
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
      // 'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse(url + options), headers: headers);
    if (response.statusCode == 200) {
      return compute(parserBranchList, response.body);
    } else {
      throw MyCustomException.fromObject(json.decode(response.body));
    }
  } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

 static Future<BranchDetail> fetchBranchDetail({required String idBranch }) async{
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse("$url/$idBranch"),headers: headers);
    if (response.statusCode ==200){
      
      var data = json.decode(response.body)['data'];
      
      BranchDetail branch = BranchDetail.fromJson(data);
    
      return branch;
    }  else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  
}
