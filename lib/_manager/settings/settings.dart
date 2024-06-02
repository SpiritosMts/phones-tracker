
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phones_tracker/_manager/myVoids.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:settings_ui/settings_ui.dart';

import '../bindings.dart';
import '../styles.dart';

/// enable map sdk in cloud and add api key from there in manifest
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

  String lang = 'English';

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 400), () {
      print('## open SettingsView');

    });
  }



  @override
  Widget build(BuildContext context) {
    return SettingsList(


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

                // Get.to(()=>MapScreen0());
              },
            ),

            SettingsTile(

              title: Text('Network & internet'),
              description: Text('Mobile, Wi-Fi, hotspot'),
              leading: Icon(Icons.wifi),
            ),
            SettingsTile(

              title: Text('Profile'),
              description: Text(cUser.name),
              leading: Icon(Icons.person),
            ),
            SettingsTile(

              title: Text('Apps'),
              description: Text('Assistant, recent apps, default apps'),
              leading: Icon(Icons.apps),
            ),

            SettingsTile(
              title: Text('Battery'),
              description: Text('100%'),
              leading: Icon(Icons.battery_full),
            ),
            SettingsTile(

              title: Text('Storage'),
              description: Text('30% used - 5.60 GB free'),
              leading: Icon(Icons.storage),
            ),
            SettingsTile(

              title: Text('Sound & vibration'),
              description: Text('Volume, haptics, Do Not Disturb'),
              leading: Icon(Icons.volume_up_outlined),
            ),
            SettingsTile(

              title: Text('Display'),
              enabled: false,
              description: Text('Dark theme, font size, brightness'),
              leading: Icon(Icons.brightness_6_outlined),
            ),
            SettingsTile(

              title: Text('Wallpaper & style'),
              description: Text('Colors, themed icons, app grid'),
              leading: Icon(Icons.palette_outlined),
            ),
            SettingsTile(

              title: Text('Accessibility'),
              description: Text('Display, interaction, audio'),
              leading: Icon(Icons.accessibility),
            ),
            SettingsTile(

              title: Text('Security'),
              description: Text('Screen lock, Find My Device, app security'),
              leading: Icon(Icons.lock_outline),
            ),
            SettingsTile(

              title: Text('Work Space'),
              description: Text(cWs),
              leading: Icon(Icons.location_on_outlined),
            ),
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
    );
  }
}
