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

  onScreenSelected(int index){
    switch (index) {
      case 0:
        updateAppbar(title:'Invoices'.tr,
    ldng: Container(),

            btns: [
          //sell
          GestureDetector(
            onTap: () {
              print('## add NEW sell invoice');
              if (invCtr.notCheckedBuyInvoices.length != 0) {
                showSnack('You have to check all buy invoices before adding new sell invoice'.tr,
                    color: snackBarError);
                return;
              }
              if (prdCtr.productsList.isEmpty) {
                showSnack('You have to register at least one product to add sell invoice'.tr,
                    color: snackBarError);
                return;
              }

              invCtr.invType = 'Multiple';
              Get.to(() => AddEditInvoice(), arguments: {
                'isAdd': true,
                'isVerified': false,
                'isBuy': false,
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: Center(
                child: Text(
                  'Sell'.tr,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: appBarButtonsCol,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          //buy
          GestureDetector(
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
        updateAppbar(title:'Inventory'.tr,
            ldng:  GetBuilder<ProductsCtr>(
          //id:'appBar',
            builder: (_) {
              //&& chCtr.selectedServer != ''
              return SizedBox(
               // width: 300,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0, top: 0.0,left: 0),
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down, color: primaryColor.withOpacity(0.7),size: 20),
                    padding: const EdgeInsets.only(right: 0, top: 10,left: 5),
                    dropdownColor:dropDownCol ,
                    //iconSize: 1,
                    value: prdCtr.selectedManufac,
                    underline: Container(),


                    isDense: false,
                    isExpanded: true,
                    items: phoneManufacturers.map((String man) {
                      return DropdownMenuItem<String>(

                          value: man,
                          child: Text(
                            man,
                            style: TextStyle(color: primaryColor.withOpacity(0.7),fontSize: 11),
                          )
                      );
                    }).toList(),
                    onChanged: (man) {
                      if(man != prdCtr.selectedManufac){
                        prdCtr.selectedManufac = man!;
                        prdCtr.runProdFilter(manu:man!);
                        showSnack('$man Devices ...');

                        Future.delayed(const Duration(milliseconds: 200), () {
                          prdCtr.update();
                        });
                      }


                    },
                  ),
                ),
              );
            }),
            btns: [

              IconButton(
                onPressed: () {
                  Get.to(()=>PhonePropertiesForm(isAdd: true,));

                },
                icon: Icon(Icons.add,color: appBarButtonsCol,),

              ),
          IconButton(
            onPressed: () {
             prdCtr.addProductsToFirestore();

            },
            icon: Icon(Icons.search,color: appBarButtonsCol,),

          ),


        ]);
        break;
      case 2:
        updateAppbar(title:'Notes'.tr,btns: [
          IconButton(
            onPressed: () {
              showAnimDialog(noteCtr.showNoteDialog());

            },
            icon: Icon(Icons.add,color: appBarButtonsCol,),

          ),
        ],ldng: Container());

        break;

      case 3:
        updateAppbar(title:'Settings'.tr,btns: [],ldng: Container());

        break;


      default:
        updateAppbar(title:'Invoices'.tr,btns: [],ldng: Container());


    }
  }



}