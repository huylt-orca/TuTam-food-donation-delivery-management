import 'dart:convert';
import 'dart:io';

import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/logging.dart';
import 'package:food_donation_delivery_app/models/collaborator.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as diolib;

class CollaboratorService{
  static const String url = "${AppConfig.SERVER}collaborators"; 
  static final log = logger;

  Future<bool> registerCollaborator(Collaborator collaborator, File avatar, File frontOfIDCard, File backOfIDCart) async {

    final dio = diolib.Dio();

    final formData = diolib.FormData.fromMap({
      'FullName': collaborator.fullName,
      'DateOfBirth': collaborator.dateOfBirth,
      'Gender': collaborator.genderNo,
      'Note': '',
      'Avatar': await diolib.MultipartFile.fromFile(avatar.path, filename: 'image.jpg'),
      'FrontOfIdCard': await diolib.MultipartFile.fromFile(frontOfIDCard.path, filename: 'image.jpg'),
      'BackOfIdCard': await diolib.MultipartFile.fromFile(backOfIDCart.path, filename: 'image.jpg'),
    });

    try {
    final response = await dio.post(
        url,
        data: formData,
         options: diolib.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        log.w('Error: ${response.data}');
      }
    } catch (error) {
      log.w('Error: $error');
    }
    return false;
  }

  static Future<bool> checkUserSendCollaboratorApplication() async {

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };

    try {
    final response = await http.get(Uri.parse('$url/is-collaborator'), headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['data'] as bool;
    } else {
      throw MyCustomException.fromObject(json.decode(response.body));
    }
    } catch(error){
      if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }
}