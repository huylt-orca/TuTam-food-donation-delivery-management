import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/comment_list.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;

class CommentService {
  static const String url = "${AppConfig.SERVER}post-comments";

  static List<CommentList> parseCommentList(String responseBody) {
    var data = json.decode(responseBody);
    var list = data['data'] as List<dynamic>;

    List<CommentList> comments =
        list.map((model) => CommentList.fromJson(model)).toList();
    return comments;
  }

  static Future<List<CommentList>> fetchCommentList({
    int page = 1,
    int pageSize = 20,
    required String postId,
  }) async {
    String options = "?pageSize=$pageSize"
        "&page=$page&postId=$postId";

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
      final response =
          await http.get(Uri.parse(url + options), headers: headers);
      if (response.statusCode == 200) {
        return compute(parseCommentList, response.body);
      } else {
        throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch (error) {
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  static Future<bool> postComment(
      {required String postId, required String content}) async {
    try {
      var headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
      };
      var body = jsonEncode({'postId': postId, 'content': content});

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch (error) {
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }
}
