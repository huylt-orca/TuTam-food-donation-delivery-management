import 'dart:convert';

import 'package:food_donation_delivery_app/exceptions/my_custom_exception.dart';
import 'package:food_donation_delivery_app/models/token_login.dart';
import 'package:food_donation_delivery_app/repositories/storage_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:food_donation_delivery_app/app_config.dart';

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  static const String url = AppConfig.SERVER;

  Future<bool> loginWithPhone(String phone, String password) async {
    var uri = Uri.parse("${url}authenticate");
    var body = jsonEncode({
      'userName': phone,
      'password': password,
      'loginRole': 0,
    });
    var headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      var response = await http.post(uri, body: body, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        TokenLogin token = TokenLogin.fromJson(responseData['data']);
        StorageRepository.saveAccessToken(token.accessToken!);
        StorageRepository.saveRefreshToken(token.refreshToken!);
        return true;
      } else {
       throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch (error) {
     if (error is MyCustomException) rethrow;
      throw Exception(error);
    }
  }

  Future<bool> loginWithGoogle() async {
    await googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    
    final uri = Uri.parse("$url/google-sign-in");

    final body = jsonEncode({'googleToken':googleSignInAuthentication.accessToken});
 
    final headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final response = await http.post(uri, body: body, headers: headers);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        TokenLogin token = TokenLogin.fromJson(responseData['data']);
        StorageRepository.saveAccessToken(token.accessToken!);
        StorageRepository.saveRefreshToken(token.refreshToken!);
        return true;
      } else {
       throw MyCustomException.fromObject(json.decode(response.body));
      }
    } catch (error) {
     if (error is MyCustomException) rethrow;
      throw Exception(error);
    }

  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    StorageRepository.removeIsRemember();
    StorageRepository.removeAccessToken();
    StorageRepository.removeRefreshToken();
    StorageRepository.removePassword();
  }
}
