
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:phones_tracker/_manager/myVoids.dart';

import '../bindings.dart';
import '../myLocale/myLocaleCtr.dart';
import '../myTheme/myThemeCtr.dart';
import '../styles.dart';

class SettingsView extends StatefulWidget {
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  /// to add *******************************************************
  /// support number


  bool theme = false;
  bool darkMode = false;
  bool background = false;
  bool notification = false;

  String lang = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 400), () {
      print('## open SettingsView');

      setState(() {
        switch (currLang) {
          case 'ar':
            lang = 'arabic';
            break;
          case 'fr':
            lang = 'french';
            break;
          default:
            lang = 'english';
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyThemeCtr>(
      builder: (_) => SettingsList(


        lightTheme: const SettingsThemeData(
          settingsListBackground: bgCol,//bg
           titleTextColor: settingTitlesColor,
           leadingIconsColor: leadingIconsColor,
          tileDescriptionTextColor: tileDescriptionTextColor,

        ),

        contentPadding: EdgeInsets.all(11),


        sections: [
          ///common
          SettingsSection(
            title: Text('general settings'.tr),
            tiles: [
              SettingsTile(
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                ),
                title: Text('Language'.tr),
                value: Text(lang.tr),
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {
                  //showLanguageDialog();
                },
              ),
              ///dark mode


            ],

          ),
          ///account
          SettingsSection(
            title: Text('account settings'.tr),
            tiles: [

              //signout

              SettingsTile(
                trailing: Icon(
                  Icons.logout,
                ),
                title: Text('Logout'.tr,),
                //value: Text('delete this account permanently'.tr),
                leading: const Icon(Icons.account_circle_outlined),
                onPressed: (BuildContext context) {
                  authCtr.signOutUser(shouldGoLogin: true);
                },
              ),

              // //delete acc
              // SettingsTile(
              //   trailing: Icon(
              //     LineIcons.minusCircle,
              //     color: Colors.redAccent,
              //   ),
              //   title: Text('Delete Account'.tr,style: TextStyle(color:Colors.redAccent ),),
              //   value: Text('delete this account permanently'.tr),
              //   leading: const Icon(Icons.no_accounts,color: Colors.redAccent,),
              //   onPressed: (BuildContext context) {
              //     authCtr.deleteAccount(cUser);
              //   },
              // ),

            ],

          ),
        ],
      ),
    );
  }
}
