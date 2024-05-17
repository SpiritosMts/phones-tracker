import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phones_tracker/_manager/bindings.dart';
import 'package:phones_tracker/invoices/invoiceCtr.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../_manager/myUi.dart';
import '../_manager/styles.dart';

class ChangeAdded extends StatelessWidget {
  final double price;
  final int qty;
  final int index;
  ChangeAdded({ required this.price,required this.qty,required this.index,});



  //###############################################################"
  //###############################################################"

  @override
  Widget build(BuildContext context) {

    return GetBuilder<InvoicesCtr>(
        initState: (_) {

          invCtr.afterReturnPriceTec.text = price.toInt().toString();
          invCtr.afterReturnQtyTec.text = qty.toString();

        },
        dispose: (_) {
        },
        builder: (ctr) => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: invCtr.invAddedKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //SizedBox(height: 20,),

                /// components

                SizedBox(height: 10,),

                customTextField(
                  textInputType: TextInputType.number,
                  controller: invCtr.afterReturnPriceTec,
                  labelText: 'Price'.tr,
                  hintText: ''.tr,
                  icon: Icons.attach_money,
                  validator: (value) {
                    final numberRegExp = RegExp(r'^\d*\.?\d+$');

                    if (value!.isEmpty) {
                      return "price can't be empty".tr;
                    }
                    if (!numberRegExp.hasMatch(value!)) {
                      return 'Please enter a valid price'.tr;
                    }

                    return null;

                  },
                ),


                SizedBox(height: 18,),
                customTextField(
                  controller: invCtr.afterReturnQtyTec,
                  labelText: 'Quantity'.tr,
                  hintText: ''.tr,
                  icon: Icons.category,
                  textInputType: TextInputType.number,
                  validator: (value) {
                    RegExp positiveIntegerPattern = RegExp(r'^\d+$');

                    if (value!.isEmpty) {
                      return "quantity can't be empty".tr;
                    }
                    if (!positiveIntegerPattern.hasMatch(value!)) {
                      return 'Please enter a valid quantity'.tr;
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
                          style: TextStyle(color: dialogBtnCancelTextCol),
                        ),
                      ),
                      //add
                      TextButton(
                        style: filledBtnStyle(),
                        onPressed: ()  {
                          //print('## fsdfsd})');

                          invCtr.changeAddedProdReturn(index);
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
