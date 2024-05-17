// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:phones_tracker/_models/buySellProd.dart';
// import 'package:phones_tracker/products/productsCtr.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
//
// import '../_manager/bindings.dart';
// import '../_manager/charts/chartsUi.dart';
// import '../_manager/firebaseVoids.dart';
// import '../_manager/myLocale/myLocaleCtr.dart';
// import '../_manager/myUi.dart';
// import '../_manager/myVoids.dart';
// import '../_manager/styles.dart';
// import '../_manager/widgets/rounded_icon_button.dart';
// import '../_models/prodChange.dart';
// import '../_models/product.dart';
//
// class ProductInfoTab extends StatefulWidget {
//   const ProductInfoTab({super.key});
//
//   @override
//   State<ProductInfoTab> createState() => _ProductInfoTabState();
// }
//
// class _ProductInfoTabState extends State<ProductInfoTab> with TickerProviderStateMixin{
//
//   late TabController _tcontroller;
//   final List<String> titleList = [
//     "History".tr,
//     "Charts".tr,
//     "Buy History".tr,
//   ];
//   String currentTitle = '';
//   Map<String,dynamic> allItems = {};//all months history
//   Map<String,dynamic> sellHis = {};//
//   Map<String,dynamic> buyHis = {};//
//   Map<String,dynamic> prodChanges = {};//
//   Map<String,dynamic> selectedMonthMap = {};//one month history
//   String selectedMonth = '';//month name
//
//   double totalBuy = 0.0;
//   double totalIncome = 0.0;
//   double totalSell = 0.0;
//   int totalSelledQty = 0;
//   int totalPurchasedQty = 0;
//   List<double> sellList =[];
//   List<double> incomeList =[];
//   List<double> qtyList =[];
//   List<String> dates =[];
//
//   // /////////////////////////////////////////////////////////////////////////
//   @override
//   void initState() {
//     super.initState();
//
//     //tab init
//     currentTitle = titleList[0];//initial tab
//     _tcontroller = TabController(length: 2, vsync: this);
//     _tcontroller.addListener(changeTitle);//listen to tab changes
//     //--------
//
//     allItems = prdCtr.selectedProd.allItems;//
//     sellHis = prdCtr.selectedProd.sellHis;//pinned
//     buyHis = prdCtr.selectedProd.buyHis;//pinned
//     sellHis = prdCtr.selectedProd.sellHis;//pinned
//
//     //printMapLength(allItems);
//     if(allItems.isNotEmpty) {
//       selectMonth(allItems.keys.first);
//       //Future.delayed(Duration(milliseconds: 0),(){selectMonth(allItems.keys.first);});
//
//     }
//
//   }
//
//   @override
//   void dispose() {
//     _tcontroller.dispose();
//     super.dispose();
//
//   }
//   void changeTitle() {
//     setState(() {
//       currentTitle = titleList[_tcontroller.index];
//
//     });
//   }
//
//   selectMonth(String month){
//
//     if(allItems[month] == null) {
//       showTos('no selected month');
//       return;
//     }
//     selectedMonth = month;//name
//
//     //selectedMonthMap = {};
//     selectedMonthMap = Map<String, dynamic>.from(allItems[month] ?? {});//make copy of 'allItems[month]'
//     print('## select: [$month] ');
//     //printJson(selectedMonthMap);
//
//
//
//     totalBuy = selectedMonthMap['totalBuy']??0.0;
//     totalIncome = selectedMonthMap['totalIncome']??0.0;
//     totalSell = selectedMonthMap['totalSell']??0.0;
//     totalSelledQty = selectedMonthMap['totalSelledQty']??0;
//     totalPurchasedQty = selectedMonthMap['totalPurchasedQty']??0;
//
//     List<String> l0 = selectedMonthMap['sellList'] as List<String> ;
//     sellList = convertStringListToDoubleList(l0.reversed.toList());
//
//     List<String> l1 = selectedMonthMap['incomeList']?? [];
//     incomeList = convertStringListToDoubleList(l1.reversed.toList());
//
//     List<String> l2 = selectedMonthMap['qtyList']?? [];
//     qtyList = convertStringListToDoubleList(l2.reversed.toList());
//
//     List<String> l3 = selectedMonthMap['timeList']?? [];
//     List<String> timesList = l3.reversed.toList();
//     dates = [];
//     timesList.forEach((time) {
//       dates.add(getDayString(time));
//     });
//     ///print('## dates = "$dates" sellList = "${sellList.length}" ');
//
//
//     ///remove these keys
//     // selectedMonthMap.remove('totalBuy');
//     // selectedMonthMap.remove('totalIncome');
//     // selectedMonthMap.remove('totalSell');
//     // selectedMonthMap.remove('totalSelledQty');
//     // selectedMonthMap.remove('totalPurchasedQty');
//     //
//     // selectedMonthMap.remove('sellList');
//     // selectedMonthMap.remove('incomeList');
//     // selectedMonthMap.remove('qtyList');
//     // selectedMonthMap.remove('timeList');
//
//
//     setState(() {});
//   }
//
//
//  void removeHisTrPrefs(String key){
//
//    String shortKey = key.substring(2);// shortKey=15 while key=0s15
//
//    //offline
//    Product updatedProd =  prdCtr.selectedProd;
//    //remove < prodChages/ buyHis/ sellHis/ > when delete hisTr // delete hisTr (0s,0b,0m)
//    if(key.startsWith("0m")) {//offline
//      prodChanges.remove(key);
//      updatedProd.prodChanges = prodChanges;
//    }
//    if(key.startsWith("0s")) {//offline
//      sellHis.remove(key);
//      updatedProd.sellHis = sellHis;
//    }
//    if(key.startsWith("0b")) {//offline
//      buyHis.remove(key);
//      updatedProd.buyHis = buyHis;
//    }
//
//    ///this can be removed cz everytime we make from json it creates allItems
//    selectedMonthMap.remove(key);//remove from "selectedMonthMap" in "allItems" when delete hisTr
//    allItems = replaceValueInMap(allItems,selectedMonth,selectedMonthMap);//update < allItems > o track the removed 'hisTr' in 'selectedMonthMap'
//    updatedProd.allItems = allItems;
//
//    print('## hisTr($key)($shortKey) removed from <${selectedMonth}> of <${updatedProd.name}> ');
//
//    if(saveToPrefs) prdCtr.saveProdLocal(updatedProd,withSelect: true);/// update product to "productsList" in prefs
//     // //////
//
//
//     //online
//    if(prdOnlineEdit){
//      if(key.startsWith("0m")) { //manual
//        deleteFromMap(
//            coll: productsColl,
//            docID: prdCtr.selectedProd.id,
//            fieldMapName: 'prodChanges',
//            mapKeyToDelete:shortKey );
//      }
//      if(key.startsWith("0s")) { //sell
//        deleteFromMap(
//            coll: productsColl,
//            docID: prdCtr.selectedProd.id,
//            fieldMapName: 'sellHis',
//            mapKeyToDelete:shortKey);
//      }
//      if(key.startsWith("0b")) { //buy
//        deleteFromMap(
//            coll: productsColl,
//            docID: prdCtr.selectedProd.id,
//            fieldMapName: 'buyHis',
//            mapKeyToDelete: shortKey);
//      }
//
//    }
//    // //////
//
//
//    showSnack('removed'.tr,color: Colors.black54);
//    setState(() {});
//    prdCtr.update();
//    if(saveToPrefs) saveAllDataLocally();//SAVE
//    prdCtr.refreshProducts();
//    //invCtr.refreshInvoices(withPrdsRefresh: true);
//  }
//
//
//
//   Map<String,dynamic> replaceValueInMap( mapInitial , keyToReplace,  selectedToReplace) {
//      Map<String,dynamic> map = mapInitial;
//      if (map.containsKey(keyToReplace)) {
//        map[keyToReplace] = selectedToReplace;
//     } else {
//       //print('## <${monthName}> not fount in products months ');
//     }
//      return map;
//   }
//   Map<String,dynamic> removeValueInMap( mapInitial , keyToRemove) {
//      Map<String,dynamic> map = mapInitial;
//      if (map.containsKey(keyToRemove)) {
//        map.remove(keyToRemove);
//     } else {
//       //print('## <${monthName}> not fount in products months ');
//     }
//      return map;
//   }
//
//   Widget currProduct(product){
//     double bottomProdName = 9;
//     double bottomProdBuy = 6;
//     bool canSell = product.currQty! > 0;
//
//     return Container(
//       padding : const EdgeInsets.all(10),
//
//       // color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           /// image + name + buy + sell
//           Row(
//             children: [
//               /// IMAGE
//               ColoredRoundedSquare(edge: 100.w / 6, color: Colors.greenAccent),
//               const SizedBox(width: 16),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding:  EdgeInsets.only(bottom: bottomProdName),
//                     child: Text('${product.name}',style: TextStyle(
//                         color: normalTextCol,
//                         fontWeight: FontWeight.w400,
//                         fontSize: 17
//                     )),
//                   ),
//
//                   ///buy price
//                   Padding(
//                     padding:  EdgeInsets.only(bottom: bottomProdBuy),
//                     child: RichText(
//                       locale: Locale(currLang!),
//                       textAlign: TextAlign.start,
//                       text: TextSpan(children: [
//                         if (true)
//                           TextSpan(
//                               text: 'buy:'.tr,
//                               style: GoogleFonts.almarai(
//                                 height: 1,
//                                 textStyle: TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
//                               )),
//                         TextSpan(
//                             text: '  ${formatNumberAfterComma2(product.currBuyPrice!)}',
//                             style: GoogleFonts.almarai(
//                               height: 1,
//                               textStyle: TextStyle(
//                                   color: product.currBuyPrice! <= 0.0 ? errorBuyCol : buyCol,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400),
//                             )),
//                         TextSpan(
//                             text: '  $currency',
//                             style: GoogleFonts.almarai(
//                               height: 1,
//                               textStyle: const TextStyle(color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
//                             )),
//                       ]),
//                     ),
//                   ),
//
//                   /// SELL PRICE
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 0),
//                     child: RichText(
//                       locale: Locale(currLang!),
//                       textAlign: TextAlign.start,
//                       //softWrap: true,
//                       text: TextSpan(children: [
//                         if (true)
//                           TextSpan(
//                               text: 'sell:'.tr,
//                               style: GoogleFonts.almarai(
//                                 height: 1,
//                                 textStyle: TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
//                               )),
//                         TextSpan(
//                             text: '  ${formatNumberAfterComma2(product.currPrice!)}',
//                             style: GoogleFonts.almarai(
//                               height: 1,
//                               textStyle: TextStyle(
//                                   color: product.currPrice! <= product.currBuyPrice! ? errorSellyCol : sellCol,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500),
//                             )),
//                         TextSpan(
//                             text: '  $currency',
//                             style: GoogleFonts.almarai(
//                               height: 1,
//                               textStyle: const TextStyle(color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
//                             )),
//                       ]),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//
//           /// QTY ( + / -) ///////////////////////////////////////////////////////////////
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 0.0),
//             child: Row(
//               children: [
//                 RoundedIconBtn(
//                   onTap: () {
//                     if(!canSell) return;
//                     prdCtr.selectProduct(product); //tap
//
//                     print('## sell "${product.name}" ');
//                     showAnimDialog(prdCtr.addBSProductDialog(isSell: true));
//
//                   },
//                   icon: Icons.remove_rounded,
//                   bgColor:canSell? plusMinusBgCol:plusMinusErrorBgCol,
//                   iconColor:canSell? plusMinusIconCol:plusMinusErrorIconCol,
//                 ),
//                 SizedBox(width: 10),
//
//                 ///QUANTITY
//                 SizedBox(
//                   width: 10.w,
//                   child: Text(
//                     '${product.currQtyReduced != product.currQty ? '${product.currQtyReduced} /' : ''} ${product.currQty} ',
//                     //'${product.currQty} ',
//                     textAlign: TextAlign.center,
//                     //'${'qty:'.tr} ${product.currQtyReduced != product.currQty ? '${product.currQtyReduced} /' : ''} ${product.currQty} ',
//                     style: TextStyle(color: product.currQty! > 0 ? qtyCol : errorQtyCol, fontSize: 15),
//                   ),
//                 ),
//
//                 SizedBox(width: 10),
//                 RoundedIconBtn(
//                     onTap: () {
//                       prdCtr.selectProduct(product); //tap
//
//                       print('## buy "${product.name}" ');
//                       showAnimDialog(prdCtr.addBSProductDialog(isSell: false));
//
//                     },
//
//                     icon: Icons.add_rounded,
//                     bgColor: plusMinusBgCol,
//                     iconColor: plusMinusIconCol),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//   Widget historyList(){
//     double bottomProdName = 9;
//     double bottomProdBuy = 6;
//
//     if (selectedMonthMap.isEmpty) {
//       return elementNotFound('no Transactions found'.tr,top:29.h);
//     }
//
//     return  AnimationLimiter(
//       child: SizedBox(
//         height: 69.h,
//         child: ListView.builder(
//
//             padding: const EdgeInsets.only(
//               top: 3,
//               bottom: 35,
//               right: 0,
//               left: 0,
//             ),
//             shrinkWrap: true,
//             reverse: false,
//             itemCount: selectedMonthMap.length,
//             itemBuilder: (BuildContext context, int index) {
//               String key = selectedMonthMap.keys.elementAt(index);
//
//               Widget historyCard =Container();
//               ProdChange? prodChange;
//               BuySellProd? bsProd;
//
//               if(key.startsWith("0m")) {//manual(0m)
//                  prodChange = ProdChange.fromJson(selectedMonthMap[key]);
//               }else if (key.startsWith("0s") || key.startsWith("0b")) { // buy(0b) & sell(0s)
//                  bsProd = BuySellProd.fromJson(selectedMonthMap[key]);
//               }
//
//               historyCard = bsProdCard(key,index,prodChange:prodChange,bsProd:bsProd,whenRemove: (){
//                 removeHisTrPrefs(key);
//               });
//
//               return AnimationConfiguration.staggeredList(
//                 position: index,
//                 duration: const Duration(milliseconds: 200),
//                 child: SlideAnimation(
//                   verticalOffset: 200.0,//how to be animated came from bottom
//                   child: FadeInAnimation(
//                     child: historyCard,
//                   ),
//                 ),
//               );
//
//             }
//         ),
//       ),
//     );
//   }
//
//   Widget tabButton(index,text,icon, {Function()? onPressed}){
//     return                 ElevatedButton(
//       onPressed: () {
//         _tcontroller.animateTo(index);
//         onPressed!();
//       },
//       style: ElevatedButton.styleFrom(
//         elevation: 0,
//         backgroundColor:_tcontroller.index==index? orangeCol.withOpacity(0.7):orangeCol.withOpacity(0.15),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(200.0),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(0.0),
//         child: Row(
//           children: [
//             Icon(icon,color:_tcontroller.index==index? Colors.white:orangeCol),
//             SizedBox(width: 7,),
//             Text(text,style: TextStyle(color:_tcontroller.index==index? Colors.white:orangeCol)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   //#########################################################################
//   //#########################################################################
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,/// tab length
//       child: Scaffold(
//         // appBar: AppBar(
//         //   bottom: TabBar(
//         //     indicatorWeight: 4,
//         //     controller: _tcontroller,
//         //     isScrollable: false,
//         //     tabs: [
//         //       Tab(icon: Icon(Icons.shopping_cart_outlined)),//info
//         //       Tab(icon: FaIcon(Icons.show_chart),),//expenses
//         //       //Tab(icon: Icon(Icons.money_off_csred_outlined),),//kridi
//         //     ],
//         //   ),
//         //
//         //   actions: <Widget>[
//         //     GetBuilder<ProductsCtr>(
//         //       //id:'appBar',
//         //         builder: (gc) {
//         //           //&& chCtr.selectedServer != ''
//         //           return allItems.isNotEmpty ? Padding(
//         //             padding: const EdgeInsets.only(top: 5.0),
//         //             child: DropdownButton<String>(
//         //               icon: Icon(Icons.arrow_drop_down, color: Colors.white),
//         //               underline: Container(),
//         //               dropdownColor:dropDownCol ,
//         //               // value:(gc.selectedServer!='' && gc.myPatients.isNotEmpty)? gc.myPatients[gc.selectedServer]!.name : 'no patients',
//         //               value: selectedMonth,
//         //               //value:'name',
//         //               items: allItems.keys.map((String month) {
//         //                 return DropdownMenuItem<String>(
//         //                   value: month,
//         //                   child: Row(
//         //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                     children: [
//         //                       Text(
//         //                         month,
//         //                         style: TextStyle(color: Colors.white),
//         //                       ),
//         //                     ],
//         //                   ),
//         //                 );
//         //               }).toList(),
//         //               onChanged: (month) {
//         //                 if(month != selectedMonth){
//         //                   selectMonth(month!);
//         //                 }
//         //
//         //
//         //               },
//         //             ),
//         //           )
//         //               : Container();
//         //         }),
//         //   ],
//         // ),
//         body: Stack(
//           alignment: Alignment.bottomCenter,
//
//           children: [
//             TabBarView(
//               controller: _tcontroller,
//               children: [
//                 /// "Sell - BUY - MANUAL" History + Product /////////////////////////////////////////////////////////////////////////////////////////////////////////
//                 Column(
//                   children: [
//                     SizedBox(height: 7),
//                     currProduct(prdCtr.selectedProd),
//                     SizedBox(height: 7),
//                     historyList(),
//
//                   ],
//                 ),
//
//                 /// Charts /////////////////////////////////////////////////////////////////////////////////////////////////////////
//                   (selectedMonthMap.length > 1) ? SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //chart sells incomes
//                       SizedBox(
//                         //height: 50.h,
//                         child:  chartGraphValues(
//                           valueInterval: 20,
//                           graphName: 'sells & incomes'.tr,
//                           dataList: [],
//                           // list { 'time':25, 'value':147 }
//                           timeListX: dates,
//                           //list [25,26 ..] // X
//                           valListY: [sellList,incomeList],
//                           chartsColors: [totalCol,winIncomeCol],// this should math the valListY in length and order
//                           //list [147,144 ..] // Y
//                           // minGraph: getDoubleMinValue(invCtr.incomes) - 500,
//                           minGraph: -1000000,
//                           //maxGraph: (getDoubleMaxValue(invCtr.totals) + 500).toInt().toDouble(),
//                           maxGraph: 10000000,
//                           extraMinMax: 300.0,
//                           width: selectedMonthMap.length >15 ? selectedMonthMap.length / 15:1,//multiplied by 100.w
//                         )
//                       ),
//                       //chart qty
//                       SizedBox(
//                         //height: 50.h,
//                         child: chartGraphValues(
//                           valueInterval: 20,
//                           graphName: 'Quantity'.tr,
//                           dataList: [],
//                           withRedLine: false,
//                           // list { 'time':25, 'value':147 }
//                           timeListX: dates,
//                           //list [25,26 ..] // X
//                           valListY: [qtyList],
//                           chartsColors: [totalCol],// this should math the valListY in length and order
//                           //list [147,144 ..] // Y
//                           // minGraph: getDoubleMinValue(invCtr.incomes) - 500,
//                           minGraph: 0,
//                           //maxGraph: (getDoubleMaxValue(invCtr.totals) + 500).toInt().toDouble(),
//                           maxGraph: 10000,
//                           extraMinMax: 300.0,
//                           width: selectedMonthMap.length >15 ? selectedMonthMap.length / 15:1,//multiplied by 100.w
//                         )
//                       ),
//
//                       SizedBox(height: 10),
//                       //----------------buy----------------
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
//                         child: RichText(
//                           locale: Locale(currLang!),
//                           textAlign: TextAlign.start,
//                           //softWrap: true,
//                           text: TextSpan(children: [
//                             WidgetSpan(
//                                 child: SizedBox(
//                                   width: 0,
//                                 )),
//                             TextSpan(
//                                 text: 'Total Buy:'.tr,
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle: TextStyle(color:normalTextCol, fontSize: 17, fontWeight: FontWeight.w500),
//                                 )),
//                             TextSpan(
//                                 text: '  ${formatNumberAfterComma2(totalBuy)}',
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
//                                 )),
//                             TextSpan(
//                                 text: '  $currency',
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle:
//                                   const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
//                                 )),
//
//                             /// buy qty
//                             TextSpan(
//                                 text: '  /  Qty:'.tr,
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle: TextStyle(color: normalTextCol, fontSize: 17, fontWeight: FontWeight.w500),
//                                 )),
//                             TextSpan(
//                                 text: '  ${totalPurchasedQty}',
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
//                                 )),
//                           ]),
//                         ),
//                       ),
//                       //----------------sell----------------
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
//                         child: RichText(
//                           locale: Locale(currLang!),
//                           textAlign: TextAlign.start,
//                           //softWrap: true,
//                           text: TextSpan(children: [
//                             WidgetSpan(
//                                 child: SizedBox(
//                                   width: 0,
//                                 )),
//                             TextSpan(
//                                 text: 'Total Sell:'.tr,
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle: TextStyle(color: normalTextCol, fontSize: 17, fontWeight: FontWeight.w500),
//                                 )),
//                             TextSpan(
//                                 text: '  ${formatNumberAfterComma2(totalSell)}',
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle: TextStyle(color: totalCol, fontSize: 18, fontWeight: FontWeight.w500),
//                                 )),
//                             TextSpan(
//                                 text: '  $currency',
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle:
//                                   const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
//                                 )),
//                             /// qty sell
//
//                             /// buy qty
//                             TextSpan(
//                                 text: '  /  Qty:'.tr,
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle: TextStyle(color: normalTextCol, fontSize: 17, fontWeight: FontWeight.w500),
//                                 )),
//                             TextSpan(
//                                 text: '  ${totalSelledQty}',
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
//                                 )),
//                           ]),
//                         ),
//                       ),
//                       //----------------income----------------
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8.0),
//                         child: RichText(
//                           locale: Locale(currLang!),
//                           textAlign: TextAlign.start,
//                           //softWrap: true,
//                           text: TextSpan(children: [
//                             WidgetSpan(
//                                 child: SizedBox(
//                                   width: 0,
//                                 )),
//                             TextSpan(
//                                 text: 'Total Income:'.tr,
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle: TextStyle(color: normalTextCol, fontSize: 17, fontWeight: FontWeight.w500),
//                                 )),
//                             TextSpan(
//                                 text: '  ${formatNumberAfterComma2(totalIncome)}',
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle: TextStyle(color: winIncomeCol, fontSize: 18, fontWeight: FontWeight.w500),
//                                 )),
//                             TextSpan(
//                                 text: '  $currency',
//                                 style: GoogleFonts.almarai(
//                                   height: 1,
//                                   textStyle:
//                                   const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
//                                 )),
//                           ]),
//                         ),
//                       ),
//                       SizedBox(height: 40),
//
//                     ],
//                   ),
//                 ): elementNotFound('no charts data to show \n make at least 3 transactions'.tr,)
//               ],
//             ),
//             Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 //history
//                 tabButton(0,'History'.tr,Icons.history,onPressed: (){
//
//                 }),
//                 SizedBox(width: 10,),
//                 //stats
//                 tabButton(1,'Stats'.tr,Icons.bar_chart_rounded,onPressed: (){
//                   //layCtr.updateAppbar(title:prdCtr.selectedProd.name,btns: []);
//
//                 }),
//
//               ],
//             ),
//           ],
//         ),
//         //##########################################################################
//       ),
//     );
//   }
// }
//
