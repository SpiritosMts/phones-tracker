import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyThemeCtr extends GetxController {

  @override
  void onInit() {
    super.onInit();
    print('## init MyThemeCtr');
    getThemeStatus();

  }

  // ThemeData? initTheme = sharedPrefs!.getString('theme') == null
  //     ? customLightTheme
  //     : sharedPrefs!.getString('theme') == 'light'
  //         ? customLightTheme
  //         : customDarkTheme;

  bool isLightTheme = false;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  saveThemeStatus() async {
    SharedPreferences pref = await _prefs;
    pref.setBool('theme', isLightTheme);
  }

  getThemeStatus() async {
    var isLight = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('theme') ?? true;
    }).obs;
    isLightTheme = await isLight.value;
    Get.changeThemeMode(isLightTheme ? ThemeMode.light : ThemeMode.dark);
  }


  onSwitch(val){
    isLightTheme = !val;
    Get.changeThemeMode(
      isLightTheme ? ThemeMode.light : ThemeMode.dark,
    );
    saveThemeStatus();
    print('## light-Mode = "${      isLightTheme ? "ON" : "OFF"}"');
    update();
  }
  // void toggleDarkMode() {
  //   if (Get.isDarkMode) {
  //     Get.changeTheme(ThemeData.light());
  //     sharedPrefs!.setString('lang', 'light');
  //   } else {
  //     Get.changeTheme(ThemeData.dark());
  //     sharedPrefs!.setString('lang', 'dark');
  //   }
  //   update();
  // }
}
