// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:phones_tracker/_manager/bindings.dart';
// import 'package:phones_tracker/products/productsCtr.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../_manager/myUi.dart';
// import '../_manager/myVoids.dart';
// import '../_manager/styles.dart';
// import '../_models/product.dart';
//
// //(not used)
// class AddBuySellProd extends StatelessWidget {
//   final bool isSell;
//
//   AddBuySellProd({required this.isSell});
//
//   //###############################################################"
//   //###############################################################"
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProductsCtr>(
//         initState: (_) {
//           //price
//           if (isSell) {
//             prdCtr.bsPriceTec.text = prdCtr.selectedProd.currPrice!.toInt().toString();
//           } else {
//             prdCtr.bsPriceTec.text = prdCtr.selectedProd.currBuyPrice!.toInt().toString();
//           }
//           //qty
//           prdCtr.bsQtyTec.text = 1.toString();
//         },
//         dispose: (_) {},
//         builder: (ctr) => SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Form(
//                 key: prdCtr.addBSProductKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     //SizedBox(height: 20,),
//
//                     /// components
//
//                     SizedBox(
//                       height: 10,
//                     ),
//
//                     customTextField(
//                       textInputType: TextInputType.number,
//                       controller: prdCtr.bsPriceTec,
//                       labelText: 'Price'.tr,
//                       hintText: ''.tr,
//                       icon: Icons.attach_money,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(RegExp(r'\d+')),
//                       ],
//                       validator: (value) {
//                         int price = 0;
//                         try {
//                           price = int.parse(value!);
//                         } catch (e) {
//                           price = 0;
//                         }
//                         if (price == 0) {
//                           return "enter a price".tr;
//                         }
//                         // if (price > prdCtr.selectedProd.currQty!) {
//                         //   return "quantity max is ".tr+'"${prdCtr.selectedProd.currQty}"';
//                         // }
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
//                       controller: prdCtr.bsQtyTec,
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
//                         } catch (e) {
//                           qty = 0;
//                         }
//                         if (qty == 0) {
//                           return "quantity can't be empty".tr;
//                         }
//                         if (isSell && qty > prdCtr.selectedProd.currQty[cWs]!) {
//                           return "quantity max is ".tr + '"${prdCtr.selectedProd.currQty[cWs]}"';
//                         }
//
//                         return null;
//                       },
//                     ),
//
//                     if (false) ...[
//                       SizedBox(
//                         height: 18,
//                       ),
//                       if (!isSell)
//                         customTextField(
//                           controller: prdCtr.societyTec,
//                           labelText: 'Society'.tr,
//                           hintText: ''.tr,
//                           icon: Icons.category,
//                         ),
//                       SizedBox(
//                         height: 18,
//                       ),
//                       if (!isSell)
//                         customTextField(
//                           controller: prdCtr.mfTec,
//                           labelText: 'MF'.tr,
//                           hintText: ''.tr,
//                           icon: Icons.category,
//                         ),
//                       SizedBox(
//                         height: 18,
//                       ),
//                       if (!isSell)
//                         customTextField(
//                           controller: prdCtr.driverTec,
//                           labelText: 'Driver'.tr,
//                           hintText: ''.tr,
//                           icon: Icons.category,
//                         ),
//                     ],
//                     SizedBox(
//                       height: 18,
//                     ),
//
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
//                               style: TextStyle(color: dialogBtnCancelTextCol),
//                             ),
//                           ),
//                           //add
//                           TextButton(
//                             style: filledBtnStyle(),
//                             onPressed: () async {
//                               if (!prdCtr.addBSProductKey.currentState!.validate()) {
//                                 print("## Error: fields not valid");
//                                 return;
//                               }
//
//                               double priceEntred = double.parse(prdCtr.bsPriceTec.text);
//                               int qtyEntred = int.parse(prdCtr.bsQtyTec.text);
//                               if (isSell) {
//                                 //sell
//                                 // Product? foundProduct = prdCtr.productsList.firstWhere((product) => product.name == invProd.name, orElse: () => Product());
//
//                               await  prdCtr.addSellProc(
//
//                                   prod: prdCtr.selectedProd,
//                                   chosenQty: int.parse(prdCtr.bsQtyTec.text),
//                                   invID: '',
//                                   clientName: '',
//                                   income: priceEntred - prdCtr.selectedProd.currBuyPrice!,
//                                   inputPrice: priceEntred, //sell price
//                                 );
//                               Get.back();//hide dialog
//                               } else {
//                                 //buy
//                                await prdCtr.addBuyProc(
//                                   prod: prdCtr.selectedProd,
//                                   chosenQty: qtyEntred,
//                                   invID: '',
//                                   clientName: '',
//                                   inputPrice: priceEntred, //buy price
//                                 );
//                                 Get.back();//hide dialog
//
//                               }
//                             },
//                             child: Text(
//                               isSell ? "Sell".tr : "Buy".tr,
//                               style: TextStyle(color: dialogBtnOkTextCol),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ));
//   }
// }
