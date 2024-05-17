// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:phones_tracker/_manager/bindings.dart';
// import 'package:phones_tracker/products/productsCtr.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../_manager/myUi.dart';
// import '../_manager/styles.dart';
//
// class AddProduct extends StatefulWidget {
//   final bool isAdd;
//
//   AddProduct({required this.isAdd});
//
//   @override
//   State<AddProduct> createState() => _AddProductState();
// }
//
// class _AddProductState extends State<AddProduct> {
//   //###############################################################"
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProductsCtr>(
//         initState: (_) {
//           if (!widget.isAdd) {//update
//
//             prdCtr.sellPriceTec.text = prdCtr.selectedProd.currPrice!.toInt().toString();
//             prdCtr.buyPriceTec.text = prdCtr.selectedProd.currBuyPrice!.toInt().toString();
//             prdCtr.qtyTec.text = prdCtr.selectedProd.currQty.toString();
//           }
//           else{//add
//             prdCtr.clearControllers();
//           }
//         },
//
//         builder: (ctr) {
//           return SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Form(
//                 key: prdCtr.addProductKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//
//                     /// components
//                     if(widget.isAdd) customTextField(
//                       controller: prdCtr.nameTec,
//                       labelText: 'Name'.tr,
//                       hintText: ''.tr,
//                       icon: Icons.shopping_cart_outlined,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "name can't be empty".tr;
//                         }
//
//                         return null;
//                       },
//                     ),
//                     SizedBox(
//                       height: 18,
//                     ),
//
//                     ///sell price
//                     customTextField(
//                       textInputType: TextInputType.number,
//                       controller: prdCtr.sellPriceTec,
//                       labelText: 'Price'.tr,
//                       hintText: ''.tr,
//                       icon: Icons.attach_money,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp(r'\d+')),
//                       ],
//                       validator: (value) {
//
//                         if (value!.isEmpty) {
//                           return "enter a price".tr;
//                         }
//
//
//                         return null;
//                       },
//                     ),
//
//                     SizedBox(
//                       height: 18,
//                     ),
//                      /// buy price
//                      customTextField(
//                       textInputType: TextInputType.number,
//                       controller: prdCtr.buyPriceTec,
//                       labelText: 'buy Price'.tr,
//                       hintText: ''.tr,
//                       icon: Icons.attach_money,
//                        inputFormatters: [
//                          FilteringTextInputFormatter.allow(RegExp(r'\d+')),
//                        ],
//                       validator: (value) {
//
//                         if (value!.isEmpty) {
//                           return "enter a price".tr;
//                         }
//
//
//                         return null;
//                       },
//                     ),
//
//                     SizedBox(
//                       height: 18,
//                     ),
//                     //qty
//                     customTextField(
//                       controller: prdCtr.qtyTec,
//                       labelText: 'Quantity'.tr,
//                       hintText: ''.tr,
//                       icon: Icons.category,
//                       textInputType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp(r'\d+')),
//                       ],
//                       validator: (value) {
//                         int qty = 0;
//                         try {
//                           qty = int.parse(value!);
//                         }catch(e){
//                           qty =0;
//                         }
//                         if (value!.isEmpty) {
//                           return "enter a qty".tr;
//                         }
//                         // if (qty==0) {
//                         //   return "quantity can't be empty".tr;
//                         // }
//                         // if (qty > prdCtr.selectedProd.currQty!) {
//                         //   return "quantity max is ".tr+'"${prdCtr.selectedProd.currQty}"';
//                         // }
//
//
//                         return null;
//                       },
//                     ),
//                     SizedBox(
//                       height: 18,
//                     ),
//
//                     SizedBox(
//                       height: 18,
//                     ),
//                     /// buttons
//                     Padding(
//                       padding: EdgeInsets.symmetric(vertical: 15.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           //cancel
//                           TextButton(
//                             style: borderBtnStyle(),
//                             onPressed: () {
//                               Get.back();
//                             },
//                             child: Text(
//                               "Cancel".tr,
//                               style: TextStyle(
//                                   color: dialogBtnCancelTextCol),
//                             ),
//                           ),
//                           //add
//                           TextButton(
//                             style: filledBtnStyle(),
//                             onPressed: () async {
//                               if (widget.isAdd) {
//                                 prdCtr.addProduct();
//                               } else {
//                                 prdCtr.updateProductWithManualChange();
//
//                               }
//                             },
//                             child: Text(
//                              widget.isAdd? "Add".tr:"Update".tr,
//                               style: TextStyle(
//                                   color: dialogBtnOkTextCol),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//         });
//   }
// }
