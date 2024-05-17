import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phones_tracker/_manager/bindings.dart';
import 'package:phones_tracker/invoices/invoiceCtr.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../_manager/myUi.dart';
import '../_manager/styles.dart';

class ChangeTotal extends StatelessWidget {
  final double price;

  ChangeTotal({ required this.price});



  //###############################################################"
  //###############################################################"

  @override
  Widget build(BuildContext context) {

    return GetBuilder<InvoicesCtr>(
        initState: (_) {
          invCtr.totalSellPriceTec.text = price.toInt().toString();
        },
        dispose: (_) {
        },
        builder: (ctr) => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: invCtr.invTotalSellKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                /// components

                SizedBox(height: 10,),

                customTextField(
                  textInputType: TextInputType.number,
                  controller: invCtr.totalSellPriceTec,
                  labelText: 'Price'.tr,
                  hintText: ''.tr,
                  icon: Icons.attach_money,
                  validator: (value) {
                    final numberRegExp = RegExp(r'^\d*\.?\d+$');

                    // if (invCtr.selectedInvoice.isBuy! && double.parse(value!) > 0) {
                    //   return "buy price must be negative".tr;
                    // }
                    if (value!.isEmpty) {
                      return "price can't be empty".tr;
                    }
                    if (!numberRegExp.hasMatch(value)) {
                      return 'Please enter a valid price'.tr;
                    }

                    return null;

                  },
                ),




                SizedBox(
                  height: 18,
                ),


                /// buttons
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //cancel
                      TextButton(
                        style: borderBtnStyle(),
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "Cancel".tr,
                          style: TextStyle(color:dialogBtnCancelTextCol),
                        ),
                      ),
                      //add
                      TextButton(
                        style: filledBtnStyle(),
                        onPressed: ()  {
                          invCtr.changeTotalInvPrice();
                        },
                        child: Text(
                          "Update".tr,
                          style: TextStyle(color: dialogBtnOkTextCol),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
