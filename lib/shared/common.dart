 import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
 import 'package:http/http.dart' as http;
import 'package:university/shared/shared.dart';

import '../component/toLogin.dart';
import '../model/Token.dart';

class CommonMethod{

  static String? FmcToken;



   static Map<String, String>  createHeader(String jwt) {
     Map<String, String> headers = {
       'Content-Type': 'application/json',
       'Accept': 'application/json',
       'Authorization': 'Bearer ' + jwt,
     };
     return headers;
   }

   static Future<String?> refreshToken()async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String useUrl = '$mainURL/api/refreshtoken';
     Map<String, String> header = {"Content-type": "application/json"};
     String refreshToken=prefs.getString("refreshToken")!;
     String jsonSource = '{"token":"$refreshToken"}';
     var url = Uri.parse(useUrl);
     var response = await http.post(url,headers:header,body:jsonSource);

     if(response.statusCode==200){

       var jsonData = json.decode(response.body);

       Token data = Token.fromJson(jsonData);
       prefs.setString("jwt", data.accessToken!);

       return data.accessToken;
     }else{
       return null;
     }


   }

   static handleGet(response, action,context,url) async{
     if (response.statusCode == 200) {
       print(" no run refresh token");
       action(response);
     } else if (response.statusCode == 403) {
       String? newToken = await CommonMethod.refreshToken();
       if (newToken == null) {
         toLogin(context);
       }else {
         print("  run refresh token");
         var responseTwo= await http.get(url, headers: CommonMethod.createHeader(newToken));
         action(responseTwo);

       }
     } else {
       throw Exception('Failed to load data');
     }
   }



}