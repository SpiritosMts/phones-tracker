import 'dart:async';

import 'package:flutter/material.dart';

//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:phones_tracker/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '_manager/myTheme/myThemeCtr.dart';
import '_manager/myVoids.dart';
import '_manager/styles.dart';
import '_manager/bindings.dart';
import '_manager/loadingScreen.dart';
import '_manager/myLocale/myLocale.dart';
import '_manager/myLocale/myLocaleCtr.dart';


SharedPreferences? sharedPrefs;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
StreamSubscription? userStream;

///analy
// FirebaseAnalytics?  analytics;
// FirebaseAnalyticsObserver? observer ;
//FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: analytics);
/// INTRO /////////
int introTimes = 0;
bool showIntro = false;

introTimesGet() async {
  introTimes = sharedPrefs!.getInt('intro') ?? 0;
  print('## introTimes_get_<$introTimes>');
}

Future<void> checkFirebase() async {
  if (await Firebase.initializeApp() != null) {
    print("## Firebase is already initialized");
  } else {
    print("## Firebase is not initialized: INITIALIZE NOW");
    await initFirebase();
  }
}

Future<void> initFirebase() async {
  /// FIREBASE_INIT

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  print('##run_main');
  WidgetsFlutterBinding.ensureInitialized(); //don't touch
  await initFirebase();

  ///PREFS
  sharedPrefs = await SharedPreferences.getInstance();

  /// RUN_APP
  runApp(MyApp()); //should contain materialApp
}

///################################################################################################################
///################################################################################################################
//
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyLocaleCtr langCtr = Get.put(MyLocaleCtr()); //lang
  MyThemeCtr themeCtr = Get.put(MyThemeCtr()); //theme
  bool introShown = false;

  @override
  void initState() {
    super.initState();
  }

  /// ///////////////////
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
        //maxMobileWidth: 100.w,
        //maxTabletWidth: 100.h,
        builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: appDisplayName,

        theme: customLightTheme,
        themeMode: ThemeMode.light,
        //light

        locale: langCtr.initlang,
        translations: MyLocale(),

        initialBinding: GetxBinding(),
        getPages: [
          GetPage(name: '/', page: () => LoadingScreen()),
          //GetPage(name: '/', page: () => ScreenManager()), //in test mode
        ],
      );
    });
  }
}


