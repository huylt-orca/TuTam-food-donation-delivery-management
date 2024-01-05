import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/post_list.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;

class PostService{
   static const String url = "${AppConfig.SERVER}posts";

  static List<PostList> parsePostList(String responseBody){
    var data = json.decode(responseBody) ;
    var list = data['data'] as List<dynamic>;
    
    List<PostList> posts = list.map((model) => PostList.fromJson(model)).toList();
    return posts;
  }

  static Future<List<PostList>> fetchPostList({
    int page = 1,
    int pageSize = 10,
  }) async{
    
   String options =
        "?pageSize=$pageSize"
        "&page=$page"
    ;

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse(url + options),headers: headers );
    if (response.statusCode == 200){
      return compute(parsePostList,response.body);
    } else{
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }
}