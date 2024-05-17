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

/// ////////// NOTES /////////////::////
 // 3 types of inv adding,waiting,checked
 // in this screen u'll find <List<InvProd> invProdsList> (prods added) and <InvProd addingCardInvProd> (adding card)
 // when send inv to fb "invProdsList" will be converted to "map" and if i open a waiting or checked inv that "map" will convert to "invProdsList"
// when waiting inv (draft,not verified yet) added it doesnt affect the treasury or products stock but if its checked=verified it does
//same  thing for deleting inv
// in adding card (the card put we use to add prods through it which has u choose the prod name from dropdown and the price textField if the type
// of inv "isBuy" then its buy inv of type "multiple" else its sell inv of type "multiple, client or delivery" and it has a slider to set qty
// or you can manually change it through the qty textField after setting prod info to add to  inv click on the arrow to switch it from [AddingCard]->[AddedCard])
//when you check a "sell inv" all prods in it will decrease its qty value and increase treasury (society money) & when checking 'buy inv' all prods will increase qty and decrease treasury &&&& "" chenge each product <currBuyPrice> ""
// all buy invoices have to be checked before adding new buy invoice
/// ////////////////////////////////////



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

                        /// ///////////////////////////////// FIELDS /////////////////////////////

                        //name
                        if(invCtr.selectedInvoice.clientName !='' && !isAdd || isAdd )  Padding(
                          padding:  EdgeInsets.only(bottom: spaceFields),
                          child: customTextField(
                            controller: invCtr.clientNameTec,
                            labelText: !isBuy? 'client name':'seller name',
                            hintText: 'Enter name'.tr,
                            icon: Icons.person,
                            enabled: isAdd,

                            validator: (value) {
                              if (value!.isEmpty) {
                                return "name can't be empty".tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        //phone
                        if(invCtr.selectedInvoice.clientPhone !='' && !isAdd || isAdd ) Padding(
                          padding:  EdgeInsets.only(bottom: spaceFields),
                          child: customTextField(
                            textInputType: TextInputType.phone,
                            controller: invCtr.clientPhoneTec,
                            labelText: 'client phone'.tr,
                            hintText: 'Enter phone'.tr,
                            icon: Icons.phone,
                            enabled: isAdd,
                          ),
                        ),
                        

                    
                        /// //////////////////////////////////////  Products  ////////////////////////////////////////////////////////////

                        SizedBox(height: 8.0),

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
                        // ListView.builder(
                        //     //physics: const NeverScrollableScrollPhysics(),
                        //
                        //     itemExtent: 130,
                        //     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        //     shrinkWrap: true,
                        //     reverse: true,
                        //     //itemCount: invCtr.InvProdsAdded.length,
                        //     itemCount:3,
                        //     itemBuilder: (BuildContext context, int index) {
                        //       //InvProd invProd = invCtr.InvProdsAdded[index];/// change
                        //       return invToAddCard();/// change
                        //     }
                        // ),

                        ///Button add / update
                       if(!isVerified) Container(
                          //color: Colors.red,
                          width: 90.w,
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),

                          child: ElevatedButton(
                            style: filledBtnStyle(),
                            onPressed: () {
                              if(isAdd) {//new inv
                                if(!isBuy){

                                }else{

                                }
                                // both buy and sell
                                invCtr.addSellInvoice();
                              } else {//waiting inv
                                if(invCtr.selectedInvoice.id!=''){
                                  if(!invCtr.selectedInvoice.isBuy!){
                                    print('checking sell invoice ....');

                                    invCtr.checkSellInvoice();
                                  }else{
                                    print('checking buy invoice ....');

                                    invCtr.checkBuyInvoice();
                                  }
                                }else{
                                  print('no invoice selected');
                                  showSnack('no invoice selected'.tr);
                                }
                          }
                        },
                            child: Text(
                              isAdd? "Send Invoice".tr:"Check Invoice".tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        /// totals(sell,buy,income) and inv ID
                        GetBuilder<InvoicesCtr>(
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
      floatingActionButton: !isAdd ? Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            ///Change Total

            if(!isVerified) FloatingActionButton(
              onPressed: () {
                //change outsell
                showAnimDialog(
                  invCtr.changeTotalSellDialog(price:invCtr.selectedInvoice.isBuy! ? invCtr.outBuyTotal:  invCtr.outSellTotal),
                  milliseconds: 200,
                );
              },
              backgroundColor: Colors.blue.withOpacity(0.3),
              heroTag: 'changeTot',
              child: const Icon(Icons.currency_exchange),
            ),
          ],
        ),
      ):null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    
    );
    
  }
}
