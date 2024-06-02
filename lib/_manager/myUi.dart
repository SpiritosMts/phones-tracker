import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phones_tracker/products/productAdd.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../_models/affectedDev.dart';
import '../_models/invProd.dart';
import '../_models/invoice.dart';
import '../_models/note.dart';
import '../_models/product.dart';
import '../affected/affDtails.dart';
import '../invoices/addEditInvoice.dart';
import '../notes/noteInfo.dart';
import '../products/productsCtr.dart';
import 'bindings.dart';
import 'myLocale/myLocaleCtr.dart';
import 'myVoids.dart';
import 'styles.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


///note
noteCard(Note note,i,{    Function()? btnOnPress,}){
  double bottomProdName = 9;
  double bottomProdBuy = 6;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3.0),
    child: GestureDetector(

      onTap: () {

        Get.to(()=>NoteInfo(note: note));
      },
      child: Container(
        // padding :  EdgeInsets.symmetric(horizontal: horizontalPadd,vertical: verticalPadd),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: productBorderCol, width: 1.5), borderRadius: BorderRadius.circular(13)),
          color: productCardColor,
          child: Stack(
            children: [
              Container(
                padding : const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// image + name + buy + sell
                    Row(
                      children: [
                        /// IMAGE
                        Container(
                            width:60,
                            child: monthSquare(note.date!)),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(bottom: bottomProdName,top: 5),
                              child: Text('${note.workerName}',style: TextStyle(
                                  color: normalTextCol,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17
                              )),
                            ),

                            ///client name
                           if(note.clientName!.isNotEmpty) Padding(
                              padding:  EdgeInsets.only(bottom: bottomProdBuy),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Topic: ',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(
                                            color: blueCol,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      )),
                                    TextSpan(
                                        text: note.clientName,
                                        style: GoogleFonts.almarai(
                                          height: 1,
                                          textStyle: TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                        )),


                                ]),
                              ),
                            ),

                            ///about
                           Padding(
                              padding:  EdgeInsets.only(bottom: bottomProdBuy),
                              child: SizedBox(
                                width: 55.w,
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,

                                textAlign: TextAlign.start,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: 'about: ',
                                        style: GoogleFonts.almarai(
                                          height: 1,
                                          textStyle: TextStyle(
                                              color: blueCol,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        )),
                                      TextSpan(
                                          text: note.description,
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle: TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                          )),


                                  ]),
                                ),
                              ),
                            ),


                          ],
                        ),
                      ],
                    ),

                  ],
                ),
              ),
             if(cUser.isAdmin || note.workSpace==cWs) Positioned(
               top: -4,
               right: -4,
               child: IconButton(
                 icon: const Icon(Icons.close),
                 color: Colors.redAccent,
                 splashRadius: 1,
                 onPressed: () async {

                   noteCtr.removeNote(note);
                 },
               ),
             ),
            ],
          ),
        ),
      ),
    ),
  );



}



affectedCard(AffectedDev affectedDev, i, {Function()? btnOnPress}) {
  double bottomPadding = 6;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3.0),
    child: GestureDetector(
      onTap: () {
        prdCtr.seletAff(affectedDev);
        Get.to(() => AffDetails(isAdd: false));
      },
      child: Container(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: productBorderCol, width: 1.5),
            borderRadius: BorderRadius.circular(13),
          ),
          color: productCardColor,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Placeholder for an image or icon
                        Container(

                          child: Icon(Icons.phone_android,size: 60,),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: bottomPadding, top: 5),
                              child: Text(
                                '${affectedDev.name}',
                                style: TextStyle(
                                  color: normalTextCol,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: bottomPadding),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'Model: ',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(
                                        color: blueCol,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: affectedDev.model.toString(),
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(
                                        color: transparentTextCol,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: bottomPadding),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'IMEI: ',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(
                                        color: blueCol,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: affectedDev.imei,
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(
                                        color: transparentTextCol,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.only(bottom: bottomPadding),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: 'State: ',
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(
                                        color: blueCol,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: affectedDev.state,
                                    style: GoogleFonts.almarai(
                                      height: 1,
                                      textStyle: TextStyle(
                                        color: transparentTextCol,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
                Positioned(
                  top: -4,
                  right: -4,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.redAccent,
                    splashRadius: 1,
                    onPressed: () async {
                      prdCtr.removeAffected(affectedDev);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Products
Widget productCard(Product product, int index) {
  double bottomProdName = 9;
  double bottomProdBuy = 6;
  double horizontalPadd = 8;
  double verticalPadd = 6;

  bool canSell = product.currQty[cWs]! > 0;

  Widget prodCard({VoidCallback? vcb}){
    goHistory(){
      prdCtr.selectProduct(product); //tap on edit
      Get.to(()=>PhonePropertiesForm(isAdd: false));
      prdCtr.update();//add id to builder
    }
    return SwipeActionCell(
      controller: prdCtr.prodsSwipeCtr,
      index: index,
      key: ValueKey(prdCtr.productsList[index]),

      // deleteAnimationDuration: 400,
      selectedForegroundColor: Colors.black.withAlpha(30),
      //Edit
      trailingActions: [
        SwipeAction(
            title: "Edit",
            performsFirstActionWithFullSwipe: true,
            color: productEditSwipeCol,
            onTap: (handler) async {
              await handler(false);

              /// EDIT
              prdCtr.selectProduct(product); //tap on edit
              Get.to(()=>PhonePropertiesForm(isAdd: false));
            }),

      ],
      //delete
      leadingActions: [
        SwipeAction(
            title: "Remove",
            nestedAction: SwipeNestedAction(
              title: "Confirm",
            ),
            color:productRemoveSwipeCol ,
            onTap: (handler) async {
              await handler(true);

              /// REMOVE
              prdCtr.removeProduct( product);
            }),
      ],

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(

          onTap: () {
            goHistory();

          },
          child: Container(
            // padding :  EdgeInsets.symmetric(horizontal: horizontalPadd,vertical: verticalPadd),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: productBorderCol, width: 1.5), borderRadius: BorderRadius.circular(13)),
              color: productCardColor,
              child: Container(
                padding : const EdgeInsets.all(10),
                // color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// image + name + buy + sell
                    Row(
                      children: [
                        /// IMAGE
                        StaticPhoneManufacturers.contains(product.manufacturer)? Image.asset(
                           'assets/images/phone-logos/${product.manufacturer}.png',
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                        ):
                        Image.asset(
                            'assets/images/phone-logos/brand.png' ,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                        //ColoredRoundedSquare(edge: 100.w / 6, color: Colors.greenAccent),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(bottom: bottomProdName),
                              child: Text('${product.name}',style: TextStyle(
                                  color: normalTextCol,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17
                              )),
                            ),

                            ///buy price
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: RichText(
                                locale: Locale(currLang!),
                                textAlign: TextAlign.start,
                                //softWrap: true,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'RAM:'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(color: transparentTextCol, fontSize: 11, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '  ${(product.ram!)}',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(
                                            color:sellCol,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500),
                                      )),

                                ]),
                              ),
                            ),

                            SizedBox(height: 3,),
                            /// SELL PRICE
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: RichText(
                                locale: Locale(currLang!),
                                textAlign: TextAlign.start,
                                //softWrap: true,
                                text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Storage:'.tr,
                                        style: GoogleFonts.almarai(
                                          height: 1,
                                          textStyle: TextStyle(color: transparentTextCol, fontSize: 11, fontWeight: FontWeight.w500),
                                        )),
                                  TextSpan(
                                      text: '  ${(product.storage!)}',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(
                                            color:sellCol,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500),
                                      )),

                                ]),
                              ),
                            ),
                            SizedBox(height: 3,),

                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: RichText(
                                locale: Locale(currLang!),
                                textAlign: TextAlign.start,
                                //softWrap: true,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Color:'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(color: transparentTextCol, fontSize: 11, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '  ${(product.color!)}',
                                      style: GoogleFonts.almarai(
                                        height: 1,
                                        textStyle: TextStyle(
                                            color:sellCol,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500),
                                      )),

                                ]),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),

                    /// QTY ( + / -)
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: RichText(
                        locale: Locale(currLang!),
                        textAlign: TextAlign.start,
                        //softWrap: true,
                        text: TextSpan(children: [
                          if (true)
                            TextSpan(
                                text: 'Qty:'.tr,
                                style: GoogleFonts.almarai(
                                  height: 1,
                                  textStyle: TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                )),
                          TextSpan(
                              text:  '${product.currQtyReduced[cWs] != product.currQty[cWs] ? '${product.currQtyReduced[cWs]} /' : ''} ${product.currQty[cWs]} ',

                              style: GoogleFonts.almarai(
                                height: 1,
                                textStyle: TextStyle(color: product.currQty[cWs]! > 0 ? qtyCol : errorQtyCol, fontSize: 15),

                          )),

                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  return prodCard();

}

///Invoice
Widget invCard(Invoice inv, int index, {bool ofToday = false}) {
  double cardHei = 130;
  Color incomeCol = inv.income! > 0 ? winIncomeCol : looseIncomeCol;

  List<Invoice> allInvs = invCtr.invoicesList;
  double dayTotalSell = allInvs[index].returnTotal!;
  double dayTotalIncome = allInvs[index].income!;
  bool newDay = true;

  /// check if its new
  if (index != 0) {
    if (getDayString(allInvs[index].timeReturn!) != getDayString(allInvs[index - 1].timeReturn!) ||
        getMonthString(allInvs[index].timeReturn!) != getMonthString(allInvs[index - 1].timeReturn!)) {
      newDay = true; // day != day-bf
    } else {
      newDay = false;
    }
  }

  /// if new calculate total
  if (newDay && index < allInvs.length) {
    for (int i = index + 1; i < allInvs.length; i++) {
      if (getDayString(allInvs[index].timeReturn!) == getDayString(allInvs[i].timeReturn!) &&
          getMonthString(allInvs[index].timeReturn!) == getMonthString(allInvs[i].timeReturn!)) {
        dayTotalSell += allInvs[i].returnTotal!;
        dayTotalIncome += allInvs[i].income!;
      } else {
        // get out from for loop
        break;
      }
    }
  }

  return GestureDetector(
    onTap: () {
      // open expenses and his tabs
      invCtr.selectInvoice(inv);
      Get.to(() => AddEditInvoice(), arguments: {
        'isAdd': false,
        'isVerified': inv.verified,
        'isBuy': false,
      });
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          /// total date
          if (newDay)
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                      child: Text(
                        '${getDayString(inv.timeReturn!)}  ${getMonthString(inv.timeReturn!)}',
                        style: TextStyle(color: normalTextCol, fontSize: 17),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: dividerColor,
                      ),
                    ),

                    ///day total
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RichText(
                        locale: Locale(currLang!),
                        textAlign: TextAlign.start,
                        //softWrap: true,

                        text: TextSpan(children: [
                          // TextSpan(
                          //     text: 'Total:',
                          //     style: GoogleFonts.almarai(
                          //       height: 1,
                          //       textStyle: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                          //     )),
                          TextSpan(
                              text: '${formatNumberAfterComma2(dayTotalIncome)}',
                              style: GoogleFonts.almarai(
                                height: 1,
                                textStyle: TextStyle(
                                    color: dayTotalIncome > 0 ? winIncomeCol : looseIncomeCol,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )),
                          TextSpan(
                              text: ' / ',
                              style: GoogleFonts.almarai(
                                height: 1,
                                textStyle: TextStyle(color: transparentTextCol, fontSize: 15, fontWeight: FontWeight.w500),
                              )),
                          TextSpan(
                              text: '${formatNumberAfterComma2(dayTotalSell)}',
                              style: GoogleFonts.almarai(
                                height: 1,
                                textStyle: TextStyle(color: totalCol, fontSize: 15, fontWeight: FontWeight.w500),
                              )),
                          TextSpan(
                              text: '  $currency',
                              style: GoogleFonts.almarai(
                                height: 1,
                                textStyle: const TextStyle(color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
                              )),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ///card
          Container(
            width: 100.w,
            height: cardHei,
            child: Stack(
              children: [
                Card(
                  color: cardColor,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: isDateToday(inv.timeReturn!) ? activeCardBorder : normalCardBorder, width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// inv index & add time
                            indexSquare(inv.timeReturn!, inv.index!, inv.verified),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// name + type
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: RichText(
                                    locale: Locale(currLang!),
                                    textAlign: TextAlign.start,
                                    //overflow: TextOverflow.ellipsis, // Set overflow behavior

                                    //softWrap: true,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              '${(!kIsWeb && inv.clientName!.length > 20) ? '${inv.clientName!.substring(0, 19)}...' : inv.clientName}',
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle: TextStyle(color: normalTextCol, fontSize: 16, fontWeight: FontWeight.w500),
                                          )),
                                     if(cUser.isAdmin) TextSpan(
                                          text: '  ${inv.workSpace!.tr}',
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle:
                                                const TextStyle(color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
                                          )),
                                    ]),
                                  ),
                                ),
                                SizedBox(height: 8),

                                /// sell return
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: RichText(
                                    locale: Locale(currLang!),
                                    textAlign: TextAlign.start,
                                    //softWrap: true,
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: 'Total:'.tr,
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle: TextStyle(color: normalTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                          )),
                                      TextSpan(
                                          text:
                                              '  ${inv.verified! ? formatNumberAfterComma2(inv.returnTotal!) : formatNumberAfterComma2(inv.outTotal!)}',
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle: TextStyle(
                                                color: !inv.isBuy! ? totalCol : looseIncomeCol,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          )),
                                      TextSpan(
                                          text: '  $currency${inv.totalChanged! ? ', changed' : ''}',
                                          style: GoogleFonts.almarai(
                                            height: 1,
                                            textStyle:
                                                const TextStyle(color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
                                          )),
                                    ]),
                                  ),
                                ),
                                SizedBox(height: 8),

                                /// income
                                if (!inv.isBuy!)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: RichText(
                                      locale: Locale(currLang!),
                                      textAlign: TextAlign.start,
                                      //softWrap: true,
                                      text: TextSpan(children: [
                                        WidgetSpan(
                                            child: SizedBox(
                                          width: 0,
                                        )),
                                        TextSpan(
                                            text: 'Income:'.tr,
                                            style: GoogleFonts.almarai(
                                              height: 1,
                                              textStyle:
                                                  TextStyle(color: normalTextCol  , fontSize: 13, fontWeight: FontWeight.w500),
                                            )),
                                        TextSpan(
                                            text: '  ${formatNumberAfterComma2(inv.income!)}',
                                            style: GoogleFonts.almarai(
                                              height: 1,
                                              textStyle: TextStyle(color: incomeCol, fontSize: 13, fontWeight: FontWeight.w500),
                                            )),
                                        TextSpan(
                                            text: '  $currency',
                                            style: GoogleFonts.almarai(
                                              height: 1,
                                              textStyle: const TextStyle(
                                                  color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
                                            )),
                                      ]),
                                    ),
                                  ),

                                if (inv.isBuy!)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: RichText(
                                      locale: Locale(currLang!),
                                      textAlign: TextAlign.start,
                                      //softWrap: true,
                                      text: TextSpan(children: [
                                        WidgetSpan(
                                            child: SizedBox(
                                          width: 0,
                                        )),
                                        TextSpan(
                                            text: 'Purchases invoice'.tr,
                                            style: GoogleFonts.almarai(
                                              height: 1,
                                              textStyle: TextStyle(
                                                  color: invBuyCol.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w500),
                                            )),
                                        TextSpan(
                                            text: '  ${inv.productsOut!.length} ${'products'.tr}',
                                            style: GoogleFonts.almarai(
                                              height: 1,
                                              textStyle: const TextStyle(
                                                  color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
                                            )),
                                      ]),
                                    ),
                                  ),
                                SizedBox(height: 0),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                ///remove
                Positioned(
                  top: 13,
                  right: (currLang == 'ar') ? null : 13, //english
                  left: (currLang == 'ar') ? 13 : null, //arabic
                  child: GestureDetector(
                    child: Icon(
                      size: 20,
                      Icons.close,
                      //weight: 50,
                      color: Colors.redAccent.withOpacity(0.5),
                    ),
                    onTap: () async {
                      invCtr.removeInvoice(inv);
                    },
                  ),
                ),

                ///icon indicate invoice state (checked or waiting)
                Positioned(
                  bottom: cardHei / 3,
                  right: (currLang == 'ar') ? null : 25, //english
                  left: (currLang == 'ar') ? 25 : null, //arabic
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: inv.verified! ? Colors.greenAccent.withOpacity(0.3) : Colors.orange.withOpacity(0.2),
                        radius: 18,
                        child: Icon(
                          color: inv.verified! ? Colors.greenAccent : Colors.orange,
                          inv.verified! ? Icons.check : Icons.access_time_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

//the card with slider
Widget addingCard({bool canRemove = false}) {
  double cardHei = 210;
  Color incomeCol = invCtr.addingCardInvProd.income! > 0 ? winIncomeCol : looseIncomeCol;
  bool isBuy = invCtr.isBuy;

  Widget buildDropdown0(List<Product> productList) {
    return Container(
      width: 50.w,

      child: DropdownButtonFormField<Product>(
        style: TextStyle(color: dialogFieldWriteCol, fontSize: 11),
        isExpanded: true,
        dropdownColor: bgCol,
        decoration: InputDecoration(
          labelText: 'Model',
          filled: false,
          isCollapsed: false,
          isDense: true,

          focusColor:  Colors.white,
          fillColor:  Colors.white,
          hoverColor: Colors.white,
          contentPadding: const EdgeInsets.only(bottom:10, right: 0, left: 10),
          // suffixIconConstraints: BoxConstraints(minWidth: 50,),
          //  prefixIconConstraints: BoxConstraints(minWidth: 50),
         // constraints:BoxConstraints(maxWidth: 20,maxHeight: 50) ,

          border: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintStyle: TextStyle(color: dialogFieldHintCol, fontSize: 14.5),

          labelStyle: TextStyle(color: dialogFieldLabelCol, fontSize: 14.5),

          errorStyle: TextStyle(color: dialogFieldErrorUnfocusBorderCol.withOpacity(.9), fontSize: 12, letterSpacing: 1),

          enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: primaryColor)),
          focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldDisableBorderCol)),

        ),
        value: invCtr.addingCardProd,
        items: productList.map((Product product) {
          return DropdownMenuItem(
            value: product,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: RichText(
                textAlign: TextAlign.start,
                maxLines: 1,
                softWrap: true,
                text: TextSpan(children: [


                  TextSpan(
                      text:product.name,
                      style: GoogleFonts.almarai(
                        height: 1,
                        textStyle: TextStyle(color: primaryColor.withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.w500),
                      )),
                  TextSpan(
                      text: '   ${product.ram} - ${product.storage}',
                      style: GoogleFonts.almarai(
                        height: 1,
                        textStyle: const TextStyle(
                            color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w400),
                      )),
                ]),
              ),
            ),

          );
        }).toList(),
        onChanged: (selectedProduct) {
          // Handle the selected product
          if (selectedProduct != null) {
            //Product prod = invCtr.selectedInvProdToAdd ;
            invCtr.addingCardProd = selectedProduct; //selected dropDown Product

            if (!isBuy) {
              invCtr.maxQty = selectedProduct.currQtyReduced[cWs]!.toDouble(); // same 2 line in initAddingCard()
              print('## currQtyReduced[cWs] = ${invCtr.maxQty}');
            } else {
              invCtr.maxQty = 20000;
            }
            invCtr.sliderVal = 0.0;

            invCtr.updateAddingCard(updatePriceField: true); //update sell price textField
            invCtr.update(['addingCard']);
            print('## Selected Product: ${selectedProduct.name}');
          }
        },
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      width: 95.w,
      height: cardHei,
      child: Stack(
        children: [
          Card(
            color: cardColor,
            elevation: 5,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: productBorderCol, width: 2), borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: invCtr.invToAddKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// /////////////////////////////////////////////////////////////////////
                        /// dropdown / price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///dropdown
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: invCtr.productsOfAddingCard.length > 0
                                  ?   buildDropdown0(invCtr.productsOfAddingCard)
                                  : Container(),
                            ),
                            SizedBox(width: 3.w),

                            ///price
                            SizedBox(
                              width: 20.w,
                              height: 70,
                              child: TextFormField(
                                //maxLength: 9,
                                onChanged: (val) {
                                  invCtr.updateAddingCard();
                                },
                                controller: invCtr.addingPriceTec,
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: normalTextCol, fontSize: 14.5),
                                validator: (value) {
                                  final numberRegExp = RegExp(r'^\d*\.?\d+$');

                                  if (value!.isEmpty || double.parse(value) == 0) {
                                    return "empty".tr;
                                  }
                                  // if (value.length > 9) {
                                  //   return "long".tr;
                                  // }
                                  if (!numberRegExp.hasMatch(value!)) {
                                    return 'not valid'.tr;
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  focusColor: Colors.white,
                                  fillColor: Colors.white,
                                  hoverColor: Colors.white,
                                  contentPadding: const EdgeInsets.only(bottom: 0, left: 5, top: 5),
                                  suffixIconConstraints: BoxConstraints(minWidth: 50),
                                  prefixIconConstraints: BoxConstraints(minWidth: 50),
                                  border: InputBorder.none,
                                  hintText: ''.tr,
                                  labelText: 'Price'.tr,
                                  labelStyle: TextStyle(color: transparentTextCol, fontSize: 14.5),
                                  hintStyle: TextStyle(color: transparentTextCol, fontSize: 14.5),
                                  errorStyle: TextStyle(color: Colors.redAccent.withOpacity(.9), fontSize: 12, letterSpacing: 1),
                                  enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldEnableBorderCol)),
                                  focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldEnableBorderCol)),
                                  errorBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldErrorUnfocusBorderCol)),
                                  focusedErrorBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldErrorUnfocusBorderCol)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 13),

                        /// - / qty / +
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13.0),
                              child: CircleAvatar(
                                backgroundColor: dialogBtnOkCol.withOpacity(.7),
                                radius: 15,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.remove, size: 19),
                                  color: Colors.white,
                                  onPressed: () {
                                   if(invCtr.sliderVal>0) {
                                      invCtr.sliderVal--;
                                      invCtr.addingQtyTec.text = invCtr.sliderVal.toInt().toString(); // slider update textField
                                      invCtr.updateAddingCard();
                                    }
                                  },
                                ),
                              ),
                            ),
                            ///qty
                            SizedBox(
                              width: 28.w,
                              height: 70,
                              child: TextFormField(
                                //maxLength: 6,
                                onChanged: (val) {
                                  try {
                                    double parsedValue = double.parse(val);

                                    if (parsedValue < invCtr.maxQty) {
                                      invCtr.sliderVal = double.parse(val); // textField update slider
                                    } else {
                                      invCtr.sliderVal = invCtr.maxQty; // textField update slider
                                    }
                                    invCtr.updateAddingCard();
                                  } catch (e) {
                                    invCtr.sliderVal = 0;
                                    //showSnack('please enter a number to update slider'.tr,color: Colors.black38.withOpacity(0.8));
                                  }
                                },
                                controller: invCtr.addingQtyTec,
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: normalTextCol, fontSize: 14.5),
                                validator: (value) {
                                  RegExp positiveIntegerPattern = RegExp(r'^\d+$');

                                  if (value!.isEmpty || double.parse(value) == 0) {
                                    return "empty".tr;
                                  }
                                  if (!positiveIntegerPattern.hasMatch(value!)) {
                                    return 'not valid'.tr;
                                  }
                                  if (double.parse(value) > invCtr.maxQty) {
                                    return '${'max='.tr} ${invCtr.maxQty.toInt()}';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  focusColor: Colors.white,
                                  fillColor: Colors.white,
                                  hoverColor: Colors.white,
                                  contentPadding: const EdgeInsets.only(bottom: 0, left: 20, top: 0),
                                  suffixIconConstraints: BoxConstraints(minWidth: 50),
                                  prefixIconConstraints: BoxConstraints(minWidth: 50),
                                  border: InputBorder.none,
                                  hintText: ''.tr,
                                  labelText: 'Qty'.tr,
                                  labelStyle: TextStyle(color: transparentTextCol, fontSize: 14.5),
                                  hintStyle: TextStyle(color: transparentTextCol, fontSize: 14.5),
                                  errorStyle: TextStyle(color: Colors.redAccent.withOpacity(.9), fontSize: 12, letterSpacing: 1),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldEnableBorderCol)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldEnableBorderCol)),
                                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldErrorUnfocusBorderCol)),
                                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldErrorUnfocusBorderCol)),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(bottom: 13.0),
                              child: CircleAvatar(
                                backgroundColor: dialogBtnOkCol.withOpacity(.7),
                                radius: 15,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.add, size: 19),
                                  color: Colors.white,
                                  onPressed: () {
                                    invCtr.sliderVal ++;
                                    invCtr.addingQtyTec.text = invCtr.sliderVal.toInt().toString(); // slider update textField
                                    invCtr.updateAddingCard();
                                  },
                                ),
                              ),
                            ),

                          ],
                        ),

                        /// /////////////////////////////////////////////////////////////////////
                        // SizedBox(height: cardHei / 15),
                        //
                        // ///sell calc
                        // if (!isBuy)
                        //   Padding(
                        //     padding: const EdgeInsets.only(bottom: 0.0),
                        //     child: RichText(
                        //       locale: Locale(currLang!),
                        //       textAlign: TextAlign.start,
                        //       //softWrap: true,
                        //       text: TextSpan(children: [
                        //         WidgetSpan(
                        //             child: SizedBox(
                        //           width: 0,
                        //         )),
                        //         TextSpan(
                        //             text: 'total Sell:'.tr,
                        //             style: GoogleFonts.almarai(
                        //               height: 1.8,
                        //               textStyle:
                        //                   const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //             )),
                        //         TextSpan(
                        //             text: ' ${formatNumberAfterComma2(invCtr.addingCardInvProd.priceSell!)} ',
                        //             style: GoogleFonts.almarai(
                        //               height: 1.8,
                        //               textStyle: const TextStyle(color: normalTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //             )),
                        //         TextSpan(
                        //             text: 'x'.tr,
                        //             style: GoogleFonts.almarai(
                        //               height: 1.8,
                        //               textStyle:
                        //                   const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //             )),
                        //         TextSpan(
                        //             text: ' (${invCtr.addingCardInvProd.qty!})  ',
                        //             style: GoogleFonts.almarai(
                        //               height: 1.8,
                        //               textStyle: const TextStyle(color: normalTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //             )),
                        //         TextSpan(
                        //             text: '='.tr,
                        //             style: GoogleFonts.almarai(
                        //               height: 1.8,
                        //               textStyle:
                        //                   const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //             )),
                        //         TextSpan(
                        //             text: ' ${formatNumberAfterComma2(invCtr.addingCardInvProd.totalSell!)} ',
                        //             style: GoogleFonts.almarai(
                        //               height: 1.8,
                        //               textStyle: TextStyle(color: totalCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //             )),
                        //
                        //         ///currency
                        //         TextSpan(
                        //             text: '  $currency',
                        //             style: GoogleFonts.almarai(
                        //               height: 1.8,
                        //               textStyle:
                        //                   const TextStyle(color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
                        //             )),
                        //       ]),
                        //     ),
                        //   ),
                        //
                        // ///buy calc
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 0.0),
                        //   child: RichText(
                        //     locale: Locale(currLang!),
                        //     textAlign: TextAlign.start,
                        //     //softWrap: true,
                        //     text: TextSpan(children: [
                        //       WidgetSpan(
                        //           child: SizedBox(
                        //         width: 0,
                        //       )),
                        //       TextSpan(
                        //           text: 'total Buy:'.tr,
                        //           style: GoogleFonts.almarai(
                        //             height: 1.8,
                        //             textStyle: const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //           )),
                        //       TextSpan(
                        //           text: ' ${formatNumberAfterComma2(invCtr.addingCardInvProd.priceBuy!)} ',
                        //           style: GoogleFonts.almarai(
                        //             height: 1.8,
                        //             textStyle: const TextStyle(color: normalTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //           )),
                        //       TextSpan(
                        //           text: 'x'.tr,
                        //           style: GoogleFonts.almarai(
                        //             height: 1.8,
                        //             textStyle: const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //           )),
                        //       TextSpan(
                        //           text: ' (${invCtr.addingCardInvProd.qty!})  ',
                        //           style: GoogleFonts.almarai(
                        //             height: 1.8,
                        //             textStyle: const TextStyle(color: normalTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //           )),
                        //       TextSpan(
                        //           text: '='.tr,
                        //           style: GoogleFonts.almarai(
                        //             height: 1.8,
                        //             textStyle: const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //           )),
                        //       TextSpan(
                        //           text: ' ${formatNumberAfterComma2(invCtr.addingCardInvProd.totalBuy!)} ',
                        //           style: GoogleFonts.almarai(
                        //             height: 1.8,
                        //             textStyle: const TextStyle(color: invBuyCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //           )),
                        //
                        //       ///currency
                        //       TextSpan(
                        //           text: '  $currency',
                        //           style: GoogleFonts.almarai(
                        //             height: 1.8,
                        //             textStyle: const TextStyle(color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
                        //           )),
                        //     ]),
                        //   ),
                        // ),
                        //
                        // ///income calc
                        // if (!isBuy)
                        //   Padding(
                        //     padding: const EdgeInsets.only(bottom: 0.0),
                        //     child: RichText(
                        //       locale: Locale(currLang!),
                        //       textAlign: TextAlign.start,
                        //       //softWrap: true,
                        //       text: TextSpan(children: [
                        //         WidgetSpan(
                        //             child: SizedBox(
                        //           width: 0,
                        //         )),
                        //         TextSpan(
                        //             text: 'income:'.tr,
                        //             style: GoogleFonts.almarai(
                        //               height: 1.8,
                        //               textStyle: TextStyle(color: normalTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //             )),
                        //         TextSpan(
                        //             text: ' ${formatNumberAfterComma2(invCtr.addingCardInvProd.income!)}',
                        //             style: GoogleFonts.almarai(
                        //               height: 1.8,
                        //               textStyle: TextStyle(color: incomeCol, fontSize: 13, fontWeight: FontWeight.w500),
                        //             )),
                        //         TextSpan(
                        //             text: '  $currency',
                        //             style: GoogleFonts.almarai(
                        //               height: 1.8,
                        //               textStyle:
                        //                   const TextStyle(color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
                        //             )),
                        //       ]),
                        //     ),
                        //   ),
                        // SizedBox(height: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // add prod to "invProdsAdded" list and conv it to "invProdMap" map

        ],
      ),
    ),
  );
}

//the card was with slider
Widget addedCard({required InvProd prodAdded, required int index, bool canRemove = false, bool editable = false}) {
  double cardHei = 140;
  double calculatedIncome = (prodAdded.qty!) * (prodAdded.priceSell! - prodAdded.priceBuy!);
  Color incomeCol = calculatedIncome > 0 ? winIncomeCol : looseIncomeCol;
  bool isBuy = invCtr.isBuy || invCtr.selectedInvoice.isBuy!;
  return GestureDetector(
    onTap: () {
      // open dialog (price / qty)

      if (editable && !isBuy) {
        showAnimDialog(
          invCtr.changeAddedDialog(price: prodAdded.priceSell!, qty: prodAdded.qty!, index: index),
          milliseconds: 200,
        );
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 95.w,
        height: cardHei,
        child: Stack(
          children: [
            Card(
              color: cardColor,
              elevation: 6,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: productBorderCol, width: 2), borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                     SizedBox(width: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///name
                            Text(
                              '${prodAdded.name}  (${prodAdded.qty})',
                              style: TextStyle(color: normalTextCol, fontSize: 18, fontWeight: FontWeight.bold),
                            ),

                            SizedBox(height: 5),

                            ///sell
                            if (!isBuy)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0.0),
                                child: RichText(
                                  locale: Locale(currLang!),
                                  textAlign: TextAlign.start,
                                  //softWrap: true,
                                  text: TextSpan(children: [
                                    WidgetSpan(
                                        child: SizedBox(
                                      width: 0,
                                    )),
                                    TextSpan(
                                        text: 'total Sell:'.tr,
                                        style: GoogleFonts.almarai(
                                          height: 1.8,
                                          textStyle:
                                              const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                        )),
                                    TextSpan(
                                        text: ' ${formatNumberAfterComma2(prodAdded.priceSell!)} ',
                                        style: GoogleFonts.almarai(
                                          height: 1.8,
                                          textStyle:
                                              const TextStyle(color: normalTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                        )),
                                    TextSpan(
                                        text: 'x'.tr,
                                        style: GoogleFonts.almarai(
                                          height: 1.8,
                                          textStyle:
                                              const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                        )),
                                    TextSpan(
                                        text: ' (${prodAdded.qty!})  ',
                                        style: GoogleFonts.almarai(
                                          height: 1.8,
                                          textStyle:
                                              const TextStyle(color: normalTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                        )),
                                    TextSpan(
                                        text: '='.tr,
                                        style: GoogleFonts.almarai(
                                          height: 1.8,
                                          textStyle:
                                              const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                        )),
                                    TextSpan(
                                        text: ' ${formatNumberAfterComma2(prodAdded.totalSell!)} ',
                                        style: GoogleFonts.almarai(
                                          height: 1.8,
                                          textStyle: TextStyle(color: totalCol, fontSize: 13, fontWeight: FontWeight.w500),
                                        )),

                                    ///currency
                                    TextSpan(
                                        text: '  $currency',
                                        style: GoogleFonts.almarai(
                                          height: 1.8,
                                          textStyle:
                                              const TextStyle(color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
                                        )),
                                  ]),
                                ),
                              ),

                            ///buy
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: RichText(
                                locale: Locale(currLang!),
                                textAlign: TextAlign.start,
                                //softWrap: true,
                                text: TextSpan(children: [
                                  WidgetSpan(
                                      child: SizedBox(
                                    width: 0,
                                  )),
                                  TextSpan(
                                      text: 'total Buy:'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: ' ${formatNumberAfterComma2(prodAdded.priceBuy!)} ',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: normalTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: 'x'.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: ' (${prodAdded.qty!})  ',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: normalTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: '='.tr,
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: transparentTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),
                                  TextSpan(
                                      text: ' ${formatNumberAfterComma2(prodAdded.totalBuy!)} ',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle: const TextStyle(color: invBuyCol, fontSize: 13, fontWeight: FontWeight.w500),
                                      )),

                                  ///currency
                                  TextSpan(
                                      text: '  $currency',
                                      style: GoogleFonts.almarai(
                                        height: 1.8,
                                        textStyle:
                                            const TextStyle(color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
                                      )),
                                ]),
                              ),
                            ),

                            ///income
                            if (!isBuy)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0.0),
                                child: RichText(
                                  locale: Locale(currLang!),
                                  textAlign: TextAlign.start,
                                  //softWrap: true,
                                  text: TextSpan(children: [
                                    WidgetSpan(
                                        child: SizedBox(
                                      width: 0,
                                    )),
                                    TextSpan(
                                        text: 'income:'.tr,
                                        style: GoogleFonts.almarai(
                                          height: 1.8,
                                          textStyle: TextStyle(color: normalTextCol, fontSize: 13, fontWeight: FontWeight.w500),
                                        )),
                                    TextSpan(
                                        text: ' ${formatNumberAfterComma2(prodAdded.income!)} ',
                                        style: GoogleFonts.almarai(
                                          height: 1.8,
                                          textStyle: TextStyle(color: incomeCol, fontSize: 13, fontWeight: FontWeight.w500),
                                        )),
                                    TextSpan(
                                        text: '  $currency',
                                        style: GoogleFonts.almarai(
                                          height: 1.8,
                                          textStyle:
                                              const TextStyle(color: transparentTextCol, fontSize: 10, fontWeight: FontWeight.w500),
                                        )),
                                  ]),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (canRemove)
              Positioned(
                top: 13,
                right: (currLang == 'ar') ? null : 13, //english
                left: (currLang == 'ar') ? 13 : null, //arabic
                child: GestureDetector(
                  child: Icon(
                    size: 20,
                    Icons.close,
                    //weight: 50,
                    color: Colors.red.withOpacity(0.65),
                  ),
                  onTap: () {
                    invCtr.invProdsList.removeAt(index);
                    invCtr.update(['addedProds']);
                    Product removedProduct = prdCtr.productsList.firstWhere(
                      (product) => product.name == prodAdded.name,
                    );

                    invCtr.productsOfAddingCard.add(removedProduct); //add again to list to find it in dropDown
                    invCtr.initAddingCard(); //after removing added card
                    invCtr.refreshInvProdsTotals();
                  },
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

/// ****** DEFAULT WIDGETS **************///////////////////////////////////////////////


Widget customFAB({String? text, IconData? icon, VoidCallback? onPressed, String? heroTag}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 00.0, vertical: 00),
    child: Container(
      // height: 40.0,
      // width: 130.0,
      //constraints: BoxConstraints(minWidth: 56.0),

      child: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: onPressed,

          heroTag: heroTag,
          //backgroundColor: yellowColHex,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon ?? Icons.add),
              SizedBox(width: 8),
              Text(
                text ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget customTextField(
    {Color? color,
    bool enabled = true,
    void Function(String)? onChanged,
    TextInputType? textInputType,
    String? hintText,
    String? labelText,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool obscure = false,
    bool isPwd = false,
    bool isDense = false,
List<TextInputFormatter>? inputFormatters,
    Function()? onSuffClick,
    IconData? icon}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Container(
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        keyboardType: textInputType,
        textInputAction: TextInputAction.done,
        obscureText: obscure,
        inputFormatters: inputFormatters,


        ///pwd


        enabled: enabled,
        style: TextStyle(color: dialogFieldWriteCol, fontSize: 14.5),
        validator: validator,

        decoration: InputDecoration(
          //enabled: false,

          isDense: isDense,
          alignLabelWithHint: false,
          filled: false,
          isCollapsed: false,

          focusColor: color ?? Colors.white,
          fillColor: color ?? Colors.white,
          hoverColor: color ?? Colors.white,
          contentPadding: const EdgeInsets.only(bottom: 0, right: 20, top: 0),
          suffixIconConstraints: BoxConstraints(minWidth: 50),
          prefixIconConstraints: BoxConstraints(minWidth: 50),
          prefixIcon: Icon(
            icon,
            color: dialogFieldIconCol,
            size: 22,
          ),
          suffixIcon: isPwd
              ? IconButton(

                  ///pwd

                  icon: Icon(
                    !obscure ? Icons.visibility : Icons.visibility_off,
                    color: dialogFieldIconCol,
                  ),
                  onPressed: onSuffClick)
              : null,
          border: InputBorder.none,
          disabledBorder: InputBorder.none,

          hintText: hintText ?? '',
          hintStyle: TextStyle(color: dialogFieldHintCol, fontSize: 14.5),

          labelText: labelText!,
          labelStyle: TextStyle(color: dialogFieldLabelCol, fontSize: 14.5),

          errorStyle: TextStyle(color: dialogFieldErrorUnfocusBorderCol.withOpacity(.9), fontSize: 12, letterSpacing: 1),

          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldEnableBorderCol)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldDisableBorderCol)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldErrorUnfocusBorderCol)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldErrorFocusBorderCol)),
        ),
      ),
    ),
  );
}

String getDayString(String time) {
  DateTime parsedDateTime = dateFormatHM.parse(time);
  String day = parsedDateTime.day.toString();

  return day;
}

getMonthString(String time) {
  return getMonthName(dateFormatHM.parse(time).month);
}

getYearString(String time) {
  return dateFormatHM.parse(time).year.toString();
}

elementNotFound(text,{double? top}){
return Padding(
  padding: EdgeInsets.only(top: top?? 35.h),
  child: Text(text, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
    textStyle:  TextStyle(
        fontSize: 23  ,
        color: elementNotFoundColor,
        fontWeight: FontWeight.w700
    ),
  )),
);
}

Widget monthSquare(String date,{bool withSec = false}) {
  DateTime dateTime;
  if(withSec){
    dateTime = dateFormatHMS.parse(date);//withSec = true
  }else{
    dateTime = dateFormatHM.parse(date);//withSec = false
  }

  String day = dateTime.day.toString();
  String monthName = getMonthName(dateTime.month);
  String weekDayName = getWeekdayName(dateTime.weekday);
  String weekDay3Name = DateFormat('EEE').format(dateTime);
  String time = DateFormat("HH:mm").format(dateTime);

  return Container(
    // color: Colors.greenAccent,

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // week
          Text(
            weekDay3Name,
            maxLines: 1,
            style: TextStyle(
              fontSize: 13,
              height: 1,
              color: squareDateCol,
            ),
          ),
          SizedBox(height: 2),
          // month number
          Container(
            //color:Colors.redAccent,
            width: 40,
            height: 40,
            child: Text(
              day,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                height: 0,
                fontWeight: FontWeight.bold,
                color: squareDateCol,
              ),
            ),
          ),
          SizedBox(height: 2),

          // time
          Text(
            time,//15:06
            maxLines: 1,
            style: TextStyle(
              fontSize: 13,
              height: 0,
              color: squareDateCol,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget indexSquare(String time, String index, verified) {
  String day = dateFormatHM.parse(time).day.toString();
  String monthName = getMonthName(dateFormatHM.parse(time).month);
  String timeString = DateFormat("HH:mm").format(dateFormatHM.parse(time));

  return Container(
    width: 70,
    height: 90,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      //color: Colors.white,
      // border: Border.all(
      //   color: Colors.white,
      //   width: 2,
      // ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Num°',
            maxLines: 1,
            style: TextStyle(
              fontSize: 13,
              height: 0.5,
              color: transparentTextCol,
            ),
          ),
          Text(
            index,
            maxLines: 1,
            style: TextStyle(
              fontSize: 26,
              height: 1.3,
              fontWeight: FontWeight.bold,
              color: verified ? Colors.greenAccent : Colors.orange,
            ),
          ),
          Text(
            timeString,
            maxLines: 1,
            style: TextStyle(
              fontSize: 13,
              height: 1,
              color: transparentTextCol,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget backGroundTemplate({Widget? child}) {
  return Container(
    //alignment: Alignment.topCenter,
    width: 100.w,
    height: 100.h,
    decoration: const BoxDecoration(
        // image: DecorationImage(
        //   //image: AssetImage("assets/images/bg.png"),
        //   image: NetworkImage("https://img.freepik.com/premium-vector/general-view-factorys-industrial-premises-from-inside_565173-3.jpg"),
        //   fit: BoxFit.cover,
        // ),
        ),
    child: child,
  );
}

Widget customButton(
    {bool reversed = false,
    bool disabled = false,
    Function()? btnOnPress,
    Widget? icon,
    String textBtn = 'button',
    double btnWidth = 200,
    Color? fillCol,
    Color? borderCol}) {
  List<Widget> buttonItems = [
    icon!,

    SizedBox(width: 10),
    Text(
      textBtn,
      style: TextStyle(
        color: btnTextCol,
        fontSize: 16,
      ),
    ),
    //Icon(Icons.send_rounded,  color: Colors.white,),
  ];

  return SizedBox(
    width: btnWidth,
    child: ElevatedButton(
      onPressed: btnOnPress!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: reversed ? buttonItems.reversed.toList() : buttonItems,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: !disabled ? fillCol ?? btnFillCol : disabledBtnFillCol,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: !disabled ? borderCol ?? btnBorderCol : disabledBtnBorderCol,
          width: 2,
        ),
      ),
    ),
  );
}

Widget prop(title, prop, {Color color = Colors.white, double spaceBetween = 15.0, String extraTxt = ''}) {
  return Padding(
    padding: EdgeInsets.only(bottom: spaceBetween),
    child: Row(
      children: [
        Text(
          '$title',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19, color: color),
        ),
        SizedBox(width: 8),
        Text(
          '$prop',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white70),
        ),
        SizedBox(width: 5),
        Text(
          '$extraTxt',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11, color: Colors.white),
        ),
      ],
    ),
  );
}

Widget animatedText(String txt, double textSize, int speed) {
  return SizedBox(
    height: 40,
    child: AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(txt,
            textStyle: GoogleFonts.indieFlower(
              textStyle: TextStyle(fontSize: textSize, color: animatedTextCol, fontWeight: FontWeight.w800),
            ),
            speed: Duration(
              milliseconds: speed,
            )),
      ],
      onTap: () {
        //debugPrint("Welcome back!");
      },
      isRepeatingAnimation: true,
      totalRepeatCount: 40,
    ),
  );
}
