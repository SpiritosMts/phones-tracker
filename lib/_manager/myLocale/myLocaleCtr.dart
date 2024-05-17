import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main.dart';


String? get currLang => Get.locale!.languageCode;

class MyLocaleCtr extends GetxController {
  Locale initlang = Locale(sharedPrefs!.getString('lang') ?? 'en');


  String? get currLang => Get.locale!.languageCode;

  void changeLang(String codeLang) {
    sharedPrefs!.setString('lang', codeLang);
    Locale locale = Locale(codeLang);
    Get.updateLocale(locale);
    print('## current lang => ${currLang}');
  }
}
