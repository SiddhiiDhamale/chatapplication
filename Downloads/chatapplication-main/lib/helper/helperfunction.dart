// import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter/material.dart';

class HelperFunctions {
  static String sharedPrefrenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPrefrenceUserNameKey = "USERNAMEKEY";
  static String sharedPrefrenceUserEmailKey = "USEREMAILKEY";

//saving data to shared prefernce..
  static Future<void> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefrenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<void> saveUserNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefrenceUserNameKey, userName);
  }

  static Future<void> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefrenceUserLoggedInKey, userEmail);
  }

  //getting data from shared preference

  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPrefrenceUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefrenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefrenceUserEmailKey);
  }
}
