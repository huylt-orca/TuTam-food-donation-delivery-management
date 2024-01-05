import 'dart:convert';
import 'dart:io';

import 'package:food_donation_delivery_app/app_config.dart';
import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/province.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class UtilsService {
  static const String urlProvince = 'https://provinces.open-api.vn/api/p/';
  static const String urlOpenStreetService =
      'https://api.openrouteservice.org/v2/directions/cycling-electric';
      // 'https://api.openrouteservice.org/v2/directions/driving-car';


  static const String url = AppConfig.SERVER;    

  static Future<List<LatLng>> fetchRouteBetweenTwoLocation({
    required  double latitudeFirst,
    required  double longitudeFirst,
    required  double latitudeSecond,
    required  double longitudeSecond
      }) async {
    final response = await http.get(Uri.parse(
      // old key
        // '$urlOpenStreetService?api_key=5b3ce3597851110001cf6248d6bfcefda05e46da94719d44138ed1a9&start=$longitudeFirst,$latitudeFirst&end=$longitudeSecond,$latitudeSecond'));

        // new key
        '$urlOpenStreetService?api_key=5b3ce3597851110001cf624806ba2182177449d4bd2f61bbe596fa23&start=$longitudeFirst,$latitudeFirst&end=$longitudeSecond,$latitudeSecond'));


    if (response.statusCode == 200) {

       var data = json.decode(response.body)['features'][0]['geometry']['coordinates'] as List<dynamic>;
      List<LatLng> resultList = [];

  for (var item in data) {
    resultList.add(LatLng(item[1] as double, item[0] as double));

    // if (item is List<dynamic> && item.length == 2) {
    //   double firstValue = (item[0] as double);
    //   double secondValue = (item[1] as double);
    //   resultList.add([secondValue, firstValue]);
    // }
  }

  return resultList;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Can\'t get');
    }
  }

  static List<Province> parserProvinceList(String responseBody) {
    var data = json.decode(responseBody);
    var list = data['data'] as List<dynamic>;
    List<Province> provinces =
        list.map((model) => Province.fromJson(model)).toList();
    return provinces;
  }

  static Future<List<Province>> fetchProvinceList() async {
    final response = await http.get(Uri.parse(urlProvince));
    if (response.statusCode == 200) {
      var data = utf8.decode(response.bodyBytes);
      var list = json.decode(data) as List<dynamic>;
      List<Province> provinces =
          list.map((model) => Province.fromJson(model)).toList();
      // print(utf8.decode(response.bodyBytes));
      // print(json.decode(response.body));
      return provinces;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Can\'t get');
    }
  }

  static Future<List<Province>> fetchDistrictList(int code) async {
    final response =
        await http.get(Uri.parse('${urlProvince + code.toString()}?depth=2'));
    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      var list = data['districts'] as List<dynamic>;
      List<Province> provinces =
          list.map((model) => Province.fromJson(model)).toList();
      return provinces;
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Can\'t get');
    }
  }

  static Future<String> uploadImage(File imageFile)async{
    try {
       final request = http.MultipartRequest(
            'POST',
            Uri.parse('$url/image'),
          );

          final file = await http.MultipartFile.fromPath('image', imageFile.path);
          request.files.add(file);

          request.headers.addAll({'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'});

          final response = await request.send();
          
          if(response.statusCode== 200){
            String responseData = await response.stream.bytesToString();
            var decodedResponse = json.decode(responseData);
            String fileUrl = decodedResponse['data'];
            return fileUrl;
          } else {
            throw Exception('Upload Image Failed');
          }
    }catch(e){
       throw Exception('Upload Image Failed');
    }
  }

  static Future<bool> checkNearbyBranchByLocation(
      {required double latitude,
      required double longitude
      }) async {

    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await StorageRepository.getAccessToken()}'
    };
    try {
    final response = await http.get(Uri.parse('${url}nearby-branch-by-location?latitude=$latitude&longitude=$longitude'), headers: headers);
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
