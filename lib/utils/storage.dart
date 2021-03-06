import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage{

  static Future<void> setString(key,value) async{
       SharedPreferences sp=await SharedPreferences.getInstance();
     
       sp.setString(key, value);
  }
  static Future<String> getString(key) async{
       SharedPreferences sp=await SharedPreferences.getInstance();
      // ¡
       return sp.getString(key);
  }
  static Future<void> remove(key) async{
       SharedPreferences sp=await SharedPreferences.getInstance();
       sp.remove(key);
  }
  static Future<void> clear() async{
       SharedPreferences sp=await SharedPreferences.getInstance();
       sp.clear();
  }
  //根据关键字返回decode的map对象
  static Future<List> parseFromEncode(String value) async{
    var target;
    try{
      
     var obj =  await  Storage.getString(value);
     target = json.decode(obj);
     print(target is Map);
    }catch (e){

    }
    return target;
  }

  

}