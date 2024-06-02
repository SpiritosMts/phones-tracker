import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phones_tracker/_manager/bindings.dart';
import 'package:phones_tracker/products/productsCtr.dart';

import '../../invoices/addEditInvoice.dart';
import '../../main.dart';
import '../../products/productAdd.dart';
import '../firebaseVoids.dart';
import '../myUi.dart';
import '../myVoids.dart';
import '../styles.dart';

class LayoutCtr extends GetxController {
  String appBarText ='Invoices';//home
  List<Widget> appBarBtns=[];
  Widget leading=Container();



  @override
  onInit() {
    super.onInit();
    print('## ## init LayoutCtr');
    sharedPrefs!.reload();
    Future.delayed(const Duration(milliseconds: 50), ()  async {
     // invIndex = (await getFieldFromFirestore(usersColl,cUser.id,'invIndex')).toInt();//onlinec
      update(['societyCash']);
      //print('## (society_Info) invIndex: $invIndex');

      //init in here not like in getbuilder
      //invCtr.refreshInvoices(online: false );// +refresh prds
      prdCtr.refreshProducts();

    });
  }
  /// *************************************************************************************


  updateAppbar({String? title,Widget? ldng,List<Widget>? btns}){
    if(title!=null) appBarText = title;
    if(btns!=null) appBarBtns=btns;
    if(ldng!=null) leading=ldng;
    update();
  }
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
  onScreenSelected(int index){
    switch (index) {
      case 0:
        updateAppbar(title:'Stats'.tr,
    ldng:
    IconButton(
      onPressed: () {
       openDrawer(); // Open the drawer when button is pressed
      },
      icon: Icon(Icons.menu,color: appBarButtonsCol,),

    ),

            btns: [

          //buy
         if(false) GestureDetector(
            onTap: () {
              print('## add NEW buy invoice');
              if (prdCtr.productsList.isEmpty) {
                showSnack('You have to register at least one product to add buy invoice'.tr,
                    color: snackBarError);
                return;
              }
              invCtr.invType = 'Multiple';
              Get.to(() => AddEditInvoice(), arguments: {
                'isAdd': true,
                'isVerified': false,
                'isBuy': true,
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: Center(
                child: Text(
                  'Buy'.tr,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: appBarButtonsCol,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ]);

        break;
      case 1:
        updateAppbar(title:'Search'.tr,
            //ldng:Container(),
            btns: [



        ]);
        break;
      case 2:
        updateAppbar(title:'Notes'.tr,btns: [

        ]);

        break;

      case 3:
        updateAppbar(title:'Profile'.tr,btns: [],);

        break;


      default:
        updateAppbar(title:'Stats'.tr,btns: [],ldng: Container());


    }
  }



}