import 'package:flutter/material.dart';
import 'package:phones_tracker/_manager/bindings.dart';
import 'package:phones_tracker/_manager/myVoids.dart';
import 'package:phones_tracker/_models/invoice.dart';
import 'package:phones_tracker/invoices/invoiceCtr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/myLocale/myLocaleCtr.dart';
import '../_manager/myUi.dart';
import '../_manager/styles.dart';

class AddEditInvoice extends StatefulWidget {
  const AddEditInvoice({super.key});

  @override
  State<AddEditInvoice> createState() => _AddEditInvoiceState();
}




class _AddEditInvoiceState extends State<AddEditInvoice> {
  bool isAdd = Get.arguments['isAdd'];// true if "new inv",false if "waiting for check"
  bool isVerified = Get.arguments['isVerified'];// true if "checked"
  bool isBuy = Get.arguments['isBuy'];// used when inv not added yet
  bool selectedIsBuy = invCtr.selectedInvoice.isBuy!;//user for inv checked or waiting

  double spaceFields = 25;




  @override
  void initState() {
    super.initState();



    if(!isAdd){///CHECK INVOICE


      invCtr.resetAddINvoice();

      invCtr.clientNameTec.text = invCtr.selectedInvoice.clientName!;
      invCtr.clientPhoneTec.text = invCtr.selectedInvoice.clientPhone!;
  

      /// convert products saved as maps in fb to model List<InvProd>
      if(invCtr.selectedInvoice.verified!){ //not checked
       invCtr.invProdsList = invCtr.convertInvProdsMapToList(invCtr.selectedInvoice.productsReturned!);
      }else{//checked
        invCtr.invProdsList = invCtr.convertInvProdsMapToList(invCtr.selectedInvoice.productsOut!);
      }

      invCtr.refreshInvProdsTotals();
      invCtr.update(['addedProds']);

      //print('## ${invCtr.InvProdsAdded}');

    }
    else{///ADD INVOICE
      invCtr.selectInvoice(Invoice());//select empty inv
      invCtr.resetAddINvoice();//reset inv values
      //invCtr.outIncomeTotal = invCtr.selectedInvoice.

    }

    invCtr.isBuy = isBuy;

    //init adding card
    invCtr.initAddingCard();//after open "addEditInvoice" screen

    print('## isBuy= $isBuy');
    //print('## invCtr.isBuy= ${invCtr.isBuy}');
    print('## isAdd= $isAdd');
  }


  //###############################################################"
  //###############################################################"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: backGroundTemplate(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Form(
                  key:  invCtr.addEditInvoiceKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        /// ////////////////// invoice type /////////////////////

                        Container(
                          child: Text(
                            //isAdd? 'New Invoice'.tr : isVerified? 'Verified Invoice'.tr : 'Returned Invoice'.tr,
                            ' ${(isBuy || selectedIsBuy)? 'Buy Invoice':'Sell Invoice'}',
                            style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 32,
                                color: normalTextCol,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        /// ///////////// invoice time //////////////////////////
                        Container(
                          child: Text(
                           isAdd? ''.tr : isVerified? '${'Time'.tr}: ${invCtr.selectedInvoice.timeReturn}'.tr : 'Time: ${invCtr.selectedInvoice.timeOut}'.tr,
                            style: TextStyle(
                                fontFamily: 'Segoe UI',
                                fontSize: 20,
                                color: normalTextCol,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        SizedBox(
                          height: 40,
                        ),

                    
                        /// //////////////////////////////////////  Products  ////////////////////////////////////////////////////////////


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: dividerColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Products'.tr,
                                style: TextStyle(color: normalTextCol, fontSize: 19),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: dividerColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spaceFields),

                        /// ///////// added prods list ///////////////////
                        GetBuilder<InvoicesCtr>(
                          id: 'addedProds',
                          builder: (ctr) {
                          return Column(
                            children: List.generate(invCtr.invProdsList.length, (index) {
                              return addedCard(
                                  prodAdded:invCtr.invProdsList[index],
                                  index: index,
                                  canRemove:  isAdd,
                                  editable: (!isAdd && !invCtr.selectedInvoice.verified!)
                              );//make the key of map as index
                            }),
                          );
                        }
                      ),

                        /// ///////// adding card /////////////////////////
                        if(isAdd ) GetBuilder<InvoicesCtr>(
                           id: 'addingCard',
                           builder: (ctr) {
                             return invCtr.productsOfAddingCard.length > 0 ?   addingCard():Container();
                           }
                         ),

                        /// /////////////////////////////////////////////////
                        SizedBox(height: 20),

                        /// totals(sell,buy,income) and inv ID
                       if(false) GetBuilder<InvoicesCtr>(
                          id: 'invTotal',
                          builder: (ctr) {
                           Color incomeCol = invCtr.outIncomeTotal > 0.0 ? winIncomeCol : looseIncomeCol;


                            return Column(
                              children: [
                                ///sell
                                if(!isBuy && !selectedIsBuy)  Padding(
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
                                          text: 'Total Sell:'.tr,

                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: logoBlue80,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),
                                      TextSpan(
                                          text: ' ${formatNumberAfterComma2(invCtr.outSellTotal)} ',

                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle:  TextStyle(
                                                color: invCtr.outSellCol,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),


                                      ///currency
                                      TextSpan(
                                          text: '  $currency',
                                          style: GoogleFonts.almarai(
                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: transparentTextCol,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500
                                            ),
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
                                          text: 'Total Buy:'.tr,

                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: transparentTextCol,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),
                                      TextSpan(
                                          text: ' ${formatNumberAfterComma2(invCtr.outBuyTotal)} ',

                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: invBuyCol,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),

                                      ///currency
                                      TextSpan(
                                          text: '  $currency',
                                          style: GoogleFonts.almarai(
                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: transparentTextCol,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),


                                    ]),
                                  ),
                                ),

                                ///income
                              if(!isBuy && !selectedIsBuy)  Padding(
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
                                          text: 'Total Income:'.tr,

                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle:  TextStyle(
                                                color: normalTextCol,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),
                                      TextSpan(
                                          text: ' ${formatNumberAfterComma2(invCtr.outIncomeTotal)}',


                                          style: GoogleFonts.almarai(

                                            height: 1.8,
                                            textStyle:  TextStyle(
                                                color: incomeCol,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),
                                      TextSpan(
                                          text: '  $currency',
                                          style: GoogleFonts.almarai(
                                            height: 1.8,
                                            textStyle: const TextStyle(
                                                color: transparentTextCol,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500
                                            ),
                                          )),


                                    ]),
                                  ),
                                ),

                                if(!isAdd)...[
                                  /// ID inv
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: RichText(
                                      locale: Locale(currLang!),
                                      textAlign: TextAlign.start,
                                      //softWrap: true,
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: 'invoice ID:'.tr,

                                            style: GoogleFonts.almarai(

                                              height: 1.8,
                                              textStyle:  TextStyle(
                                                  color: normalTextCol,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            )),
                                        TextSpan(
                                            text: ' ${invCtr.selectedInvoice.id}',


                                            style: GoogleFonts.almarai(

                                              height: 1.8,
                                              textStyle:  TextStyle(
                                                  color: transparentTextCol,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            )),

                                      ]),
                                    ),
                                  ),
                                  /// index inv
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: RichText(
                                      locale: Locale(currLang!),
                                      textAlign: TextAlign.start,
                                      //softWrap: true,
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: 'invoice index:'.tr,

                                            style: GoogleFonts.almarai(

                                              height: 1.8,
                                              textStyle:  TextStyle(
                                                  color: normalTextCol,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            )),
                                        TextSpan(
                                            text: ' ${invCtr.selectedInvoice.index}',


                                            style: GoogleFonts.almarai(

                                              height: 1.8,
                                              textStyle:  TextStyle(
                                                  color: transparentTextCol,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            )),

                                      ]),
                                    ),
                                  ),
                                ]


                              ],
                            );
                          }
                        ),
                        SizedBox( height:20),

                      ],
                    ),
                  ),
                ),
              ),
              /// back_btn
              Positioned(
                top: 25,
                left: 5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 35,
                        height: 35,
                        color: Colors.transparent,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      //color: yellowColHex,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      /// BUTTONS
      floatingActionButton:Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///addinv
            FloatingActionButton(
              onPressed: () {
                if(isAdd) {//new inv

                  // both buy and sell
                  invCtr.addSellInvoice();
                } else {//waiting inv
                  if(invCtr.selectedInvoice.id!=''){
                    if(!invCtr.selectedInvoice.isBuy!){
                      print('checking sell invoice ....');

                      invCtr.checkSellInvoice();
                    }else{
                      print('checking buy invoice ....');

                      //invCtr.checkBuyInvoice();
                    }
                  }else{
                    print('no invoice selected');
                    showSnack('no invoice selected'.tr);
                  }
                }
              },
              backgroundColor: primaryColor.withOpacity(0.7),
              heroTag: 'addarr',
              child: const Icon(Icons.check),

            ),
            ///addprod
            if(!isVerified && isAdd) FloatingActionButton(
              onPressed: () {
                invCtr.addInvProdToList();

              },
              backgroundColor: primaryColor.withOpacity(0.7),
              heroTag: 'addarr',
              child: const Icon(Icons.add_shopping_cart_outlined),
            ),


          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    
    );
    
  }
}
