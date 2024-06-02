import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:phones_tracker/_models/invoice.dart';
import 'package:phones_tracker/invoices/changeTotalSellDialog.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../_manager/bindings.dart';
import '../_manager/firebaseVoids.dart';
import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import '../_models/invProd.dart';
import '../_models/product.dart';
import '../main.dart';
import 'addEditInvoice.dart';
import 'changeAddedDialog.dart';

class InvoicesCtr extends GetxController {
  Invoice selectedInvoice = Invoice();
  List<Invoice> invoicesList = []; // list of invoices (home)
  List<Invoice> notCheckedSellInvoices = [];
  List<Invoice> notCheckedBuyInvoices = [];

  //List<Invoice> orderedInvs =[];//once when loaded
  bool isBuy = false;
  bool atInit = false;
  String invoicesListKey = 'invoicesList';

  InvProd addingCardInvProd = InvProd(); //current adding invProd (AddingCard)
  Product addingCardProd = Product(); //selected product of dropDown in "AddingCard"
  List<InvProd> invProdsList = []; //added prods list those which was an "AddingCard"
  List<Product> productsOfAddingCard = []; //available dropdown prods can be  chosen in "AddingCard"
  Map<String, dynamic> invProdsMap = {}; // "invProdsList" converted to map to add it to fb
  String invType = ''; // Multiple, delivery , client

  double sliderVal = 20.0;
  double maxQty = 700.0;
  double outIncomeTotal = 0.0;
  double outSellTotal = 0.0;
  double outBuyTotal = 0.0;

  double returnIncomeTotal = 0.0;
  double returnSellTotal = 0.0;
  double returnBuyTotal = 0.0;

  Color outSellCol = Colors.blue;

  int invIndex =0;

  selectInvoice(Invoice inv) {
    //invType = inv.type!;
    selectedInvoice = inv;

    print('## INvoice <${inv.id}> selected');
  }

  GlobalKey<FormState> invTotalSellKey = GlobalKey<FormState>(); //total price to change (bf check)
  final totalSellPriceTec = TextEditingController();

  GlobalKey<FormState> invAddedKey = GlobalKey<FormState>(); //each product to change price (bf check)
  final afterReturnPriceTec = TextEditingController();
  final afterReturnQtyTec = TextEditingController();

  GlobalKey<FormState> invToAddKey = GlobalKey<FormState>(); // price / qty in adding card
  final addingPriceTec = TextEditingController();
  final addingQtyTec = TextEditingController();

  GlobalKey<FormState> addEditInvoiceKey = GlobalKey<FormState>();
  final clientNameTec = TextEditingController();
  final clientPhoneTec = TextEditingController();

  @override
  onInit() {
    super.onInit();
    print('## init invCtr');
    sharedPrefs!.reload();
    Future.delayed(const Duration(milliseconds: 50), () async {
      invCtr.refreshInvoices(online: false); // +refresh prds
    });
  }


  /// /////////////////////////////////  Graph  ///////////////////////////////////
  refreshInvoices({bool online = true, bool withPrdsRefresh = true}) async {
    invoicesList = await getAlldocsModelsFromFb<Invoice>(
        true, invoicesColl, (json) => Invoice.fromJson(json),
        localKey: invoicesListKey);

    invIndex = invoicesList.length+1;
    //print('## refreshing all invoices ...');

    invoicesList.sort((a, b) {
      //order by date
      DateTime timeA = dateFormatHM.parse(a.timeReturn!);
      DateTime timeB = dateFormatHM.parse(b.timeReturn!);
      return timeB.compareTo(timeA);
    });
    update();

    notCheckedSellInvoices = invoicesList
        .where((invoice) => (invoice.verified == false && invoice.isBuy == false))
        .toList(); //not chcked sell invs load
    notCheckedBuyInvoices =
        invoicesList.where((invoice) => (invoice.verified == false && invoice.isBuy == true)).toList(); //not chcked buy invs load
    update();

    print(
        '## Refresh ## Invoices (${invoicesList.length}) [${online ? 'DB' : 'PREFS'}], notCheckedSellInvoices=[${notCheckedSellInvoices.length}],  notCheckedBuyInvoices=[${notCheckedBuyInvoices.length}], ');

    if (withPrdsRefresh) prdCtr.refreshProducts(online: online); // (DB) when refresh invoices



  }

  Map<String, Map<String, dynamic>> allItems = {}; //


  //add invoice to fb //DB
  addSellInvoice() {
    if (addEditInvoiceKey.currentState!.validate()) {
      if (invProdsList.isEmpty) {
        showSnack('you have to add at least one product'.tr, color: Colors.black38.withOpacity(0.8));
        return;
      }

      showNoHeader(
        txt: 'Are you sure you want to send this invoice ?'.tr,
        icon: Icons.send,
        btnOkColor: Colors.green,
        btnOkText: 'Send'.tr,
      ).then((toAllow) async {
        // if admin accept
        if (toAllow) {
          try {
            showLoading(text: 'Loading'.tr);

            convertInvProdsListToMap();

            String specificID = Uuid().v1();
            Invoice invoiceToAdd = Invoice(
              id: specificID,

              clientName: clientNameTec.text,
              clientPhone: clientPhoneTec.text,
              worker: cUser.name,
              workSpace: cWs,
              productsOut: invProdsMap,
              // prods map
              outTotal: isBuy ? -1 * outBuyTotal : outSellTotal,
              // add to user cz its sell
              timeOut: todayToString(showSeconds: true),
              timeReturn: todayToString(showSeconds: true),
              verified: false,
              totalChanged: false,
              isBuy: isBuy,
              index: invIndex.toString(),

              ///after return
              //timeReturn: todayToString(),
              productsReturned: {},
              returnTotal: 0.0,
              income: 0.0,
            );
            Map<String, dynamic> invoiceToAddMap = invoiceToAdd.toJson();


            //online
            if (invOnlineAdd) {
              var value = await addDocument(
                fieldsMap: invoiceToAddMap,
                coll: invoicesColl,
                specificID: specificID,
              );
            }

            //success
            Future.delayed(const Duration(milliseconds: 500), () async {

              ///this await is important!
              invCtr.refreshInvoices(withPrdsRefresh: true);
              update();
              Get.back();
              Get.back();
              print("## Success to add invoice ## ");
            });
          } catch (error) {
            print("## Failed to add invoice: $error");
          }
        }
      });
    }
  }

  //zeroi fields
  resetAddINvoice() {
    clientNameTec.text = '';
    clientPhoneTec.text = '';
 

    invProdsList.clear();
    update(['addedProds']);
    outIncomeTotal = 0.0;
    outSellTotal = 0.0;
    outBuyTotal = 0.0;
    sliderVal = 20.0;
    isBuy = false;

    atInit=true;
    //productsOfAddingCard = prdCtr.productsList;/// init all products

    initAddingCard(); //when zeroi fields
    invProdsMap.clear();
  }

  //reset the adding card values exmp 'select first product in dropdowwn'
  initAddingCard() {
    addingCardInvProd = InvProd();



    if (isBuy) {
      if(atInit)  invCtr.productsOfAddingCard = prdCtr.productsList.toList(); //show all prods
      addingCardProd = (productsOfAddingCard.isNotEmpty ? productsOfAddingCard[0] : Product());
      invCtr.maxQty = 20000;
    } else {
      if(atInit)  invCtr.productsOfAddingCard = prdCtr.productsList.where((product) => product.currQty[cWs]! > 0).toList(); //show only prods that have qty
      addingCardProd = (productsOfAddingCard.isNotEmpty ? productsOfAddingCard[0] : Product());
      invCtr.maxQty = addingCardProd.currQtyReduced[cWs]!.toDouble();
    }

    atInit = false;
    invCtr.sliderVal = 0.0;

    //addingQtyTec.text = addingCardProd.currQty.toString();//selected Prod => textField (qty)
    addingQtyTec.text = '0';
    if (isBuy) {
      addingPriceTec.text = addingCardProd.currBuyPrice!.toInt().toString();
    } else {
      addingPriceTec.text = addingCardProd.currPrice!.toInt().toString(); //selected Prod => textField (price)
    }

    updateAddingCard(updatePriceField: true);
    invCtr.update(['addingCard']);
  }

  //update that card of adding products every time we change price,qty or move slider or change prod in dropdown
  updateAddingCard({bool updatePriceField = false}) {
    InvProd invProd = invCtr.addingCardInvProd;

    ///just at first when init the adding card
    if (updatePriceField) {
      //init qty txtF
      addingQtyTec.text = '0';
      //addingQtyTec.text = invCtr.addingCardProd.currQty.toString();//selected Prod => textField (qty)

      //init buy
      invProd.priceBuy = invCtr.addingCardProd.currBuyPrice; //from dropDown
      invProd.priceSell = invCtr.addingCardProd.currPrice; //from dropDown

      //init price txtF
      if (!isBuy) {
        addingPriceTec.text = invCtr.addingCardProd.currPrice!.toInt().toString(); //selected Prod => textField (qty)
      } else {
        addingPriceTec.text = invCtr.addingCardProd.currBuyPrice!.toInt().toString(); //selected Prod => textField (qty)
      }
    }

    ///
      invProd.qty = int.tryParse(invCtr.addingQtyTec.text) ?? 0;
      if (!isBuy) {
        invProd.priceSell = double.tryParse(invCtr.addingPriceTec.text) ?? 0.0;
      } else {
        invProd.priceBuy = double.tryParse(invCtr.addingPriceTec.text) ?? 0.0;
      }
    ///if (invToAddKey.currentState != null && invToAddKey.currentState!.validate()) {}

    invProd.name = invCtr.addingCardProd.name; //from dropDown
    //invProd.priceBuy = invCtr.addingCardProd.currBuyPrice;//from dropDown

    invProd.totalBuy = invProd.qty! * invProd.priceBuy!;
    invProd.totalSell = invProd.qty! * invProd.priceSell!; //not used if "isBuy"
    invProd.income = invProd.totalSell! - invProd.totalBuy!; //not used if "isBuy"

    //sliderVal= invProd.qty!.toDouble();//update slider with (qty)

    //#####
    invCtr.addingCardInvProd = invProd;
    update(['addingCard']);
  }

  // arrow in adding card
  addInvProdToList() {
    if (invToAddKey.currentState != null && invToAddKey.currentState!.validate()) {
      if (addingCardInvProd.qty! < 1) {
        showSnack('please provide the quantity'.tr);
        print('## please provide the quantity');
        return;
      }

      invProdsList.add(addingCardInvProd);
      update(['addedProds']);
      refreshInvProdsTotals(); //calculate total buy sell income

      //remove this prod from next prods list, to not show same prod again in dropdown list
      String productNameToRemove = addingCardInvProd.name!;
      if(true){
        print('## before ${productsOfAddingCard.length}');
        productsOfAddingCard.removeWhere((product) => product.name == productNameToRemove);
        print('## after ${productsOfAddingCard.length}');

      }

      /// reset adding card REMOVING the added ones
      if (productsOfAddingCard.isNotEmpty) initAddingCard(); //after adding new addingCard
      invCtr.update(['addingCard']);
    }
  }

  //refresh total "sell,buy,inc" of inv (exmp: when add new prod)
  refreshInvProdsTotals({bool withSellTotal = true, bool withBuyTotal = true}) {
    if (withSellTotal) outSellTotal = 0.0;
    if (withBuyTotal) outBuyTotal = 0.0;
    outIncomeTotal = 0.0;

    for (var invProd in invProdsList) {
      if (withSellTotal) {
        outSellTotal += invProd.totalSell ?? 0.0;
        outSellCol = Colors.blue;
      }

      if (withBuyTotal) {
        outBuyTotal += invProd.totalBuy ?? 0.0;
      }
      //outIncomeTotal += invProd.income ?? 0.0;
    }
    outIncomeTotal = outSellTotal - outBuyTotal;
    update(['invTotal']);
  }



  /// /////////////////////////////////  CHECK   ////////////////////////////////////////////

  //check inv this made to allow user to change prods price and qty he made //DB
  Future<void> checkSellInvoice() async {
    showNoHeader(
      txt: 'Are you sure you want to check this invoice ?'.tr,
      icon: Icons.check,
      btnOkColor: Colors.green,
      btnOkText: 'Check'.tr,
    ).then((toAllow) async {
      // if admin accept
      if (toAllow) {
        /// ///////////  check sell /////////////////////

        try {
          showLoading(text: 'Loading'.tr); //--------

          await Future.wait<void>([]);

          check() async {
            //check prods qty should not be less than 0
            for (InvProd invProd in invProdsList) { /// ********************* FOR
              Product? foundProduct = prdCtr.productsList.firstWhere((product) => product.name == invProd.name, orElse: () => Product());

              if (foundProduct.currQty[cWs]! - invProd.qty! < 0) {
                showSnack('product <${foundProduct.name}> qty error'.tr, color: Colors.black54);
                print('## Failed to check sell invoice: <${foundProduct.name}> qty error');
                //so either u change sell qty in inv or add new qty to product
                throw Exception('## Exception ');
              }
            }
            convertInvProdsListToMap();
            //offline
            Invoice updatedInv = getInvoiceById(invCtr.selectedInvoice.id!);
            updatedInv.productsReturned = invProdsMap;
            updatedInv.returnTotal = outSellTotal;
            updatedInv.income = outIncomeTotal;
            updatedInv.verified = true;
            updatedInv.totalChanged = outSellTotal != selectedInvoice.outTotal;

            Map<String, dynamic> invoiceToCheck = {
              //'timeReturn': todayToString(),
              'productsReturned': invProdsMap,
              'returnTotal': outSellTotal,
              'income': outIncomeTotal,
              'verified': true,
              'totalChanged': outSellTotal != selectedInvoice.outTotal,
            };

            //online
            if (invOnlineEdit) {
              var value = await updateDoc(
                fieldsMap: invoiceToCheck,
                coll: invoicesColl,
                docID: invCtr.selectedInvoice.id!,
              );
            }

            /// update each product with sellProc with FOR
            if (checkInvProductsExist(invProdsList)) {
              //check if all prods exist now
              for (InvProd invProd in invProdsList) {
                ///for all products inn invoice
                //make sell procedure for all of those prods
                Product? foundProduct = prdCtr.productsList.firstWhere((product) => product.name == invProd.name, orElse: () => Product());
                await prdCtr.addSellProc(
                    prod: foundProduct,
                    inputPrice: invProd.priceSell!,
                    chosenQty: invProd.qty!,
                    invID: invCtr.selectedInvoice.id!,
                    income: invProd.income!,
                    clientName: invCtr.selectedInvoice.clientName!);
                //print('## inv<${selectedInvoice.id}> : product<${foundProduct.name}>qty<${invProd.qty!}>  selled');
              }
            } else {
              print('## Failed to sell  qty: not all products in invoice exist NOW');
              throw Exception('## Exception ');
            }


            // ----- success

            ///SAVE
            Future.delayed(const Duration(milliseconds: 2000), () {
              invCtr.refreshInvoices(withPrdsRefresh: true);
              update();
              Get.back();
              Get.back(); // --hide loading
              showTos('Invoice has been checked'.tr, color: Colors.green.withOpacity(0.7));
              print("## invoice<${selectedInvoice.index}/${invoicesList.length}> checked + products qty affected ##");

            });
          }

          await check();

        } catch (error) {
          print("## Failed to check sell invoice: $error");
        }
      }
    });
  }


  //change added single prod price/qty (waiting inv)
  changeAddedProdReturn(int index) {
    if (invAddedKey.currentState!.validate()) {
      invProdsList[index].priceSell = double.tryParse(afterReturnPriceTec.text) ?? 0.0;
      invProdsList[index].qty = int.tryParse(afterReturnQtyTec.text) ?? 0;
      invProdsList[index].totalSell = invProdsList[index].qty! * invProdsList[index].priceSell!;
      invProdsList[index].totalBuy = invProdsList[index].qty! * invProdsList[index].priceBuy!;
      invProdsList[index].income = invProdsList[index].totalSell! - invProdsList[index].totalBuy!;
      print('## ${invProdsList[index].name} => ${invProdsList[index].priceSell} (${invProdsList[index].qty})');
      refreshInvProdsTotals();
      invCtr.update(['addedProds']);
      Get.back();
    }
  }

  //change total sell of inv (draft)
  changeTotalInvPrice() {
    if (invTotalSellKey.currentState!.validate()) {
      if (invCtr.selectedInvoice.isBuy!) {
        outBuyTotal = double.tryParse(totalSellPriceTec.text) ?? 0.0;
        print('## outBuyTotal => ${outBuyTotal} ');
        refreshInvProdsTotals(withBuyTotal: false);
      } else {
        outSellTotal = double.tryParse(totalSellPriceTec.text) ?? 0.0;
        outSellCol = Colors.purple;
        print('## outSellTotal => ${outSellTotal} ');
        refreshInvProdsTotals(withSellTotal: false);
      }

      invCtr.update(['invTotal']);
      Get.back();
    }
  }

  /// change price or qty of added product  'DIALOG'
  changeAddedDialog({required double price, required int qty, required int index}) {
    return AlertDialog(
      backgroundColor: dialogBgCol,
      title: Text(
        'Change price/qty'.tr,
        style: TextStyle(
          color: dialogTitleCol,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: ChangeAdded(price: price, qty: qty, index: index),
    );
  }

  /// change total sell of invoice  'DIALOG'
  changeTotalSellDialog({required double price}) {
    return AlertDialog(
      backgroundColor: dialogBgCol,
      title: Text(
        'Change total sell'.tr,
        style: TextStyle(
          color: dialogTitleCol,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: ChangeTotal(price: price),
    );
  }

  /// /////////////////////////////////  Remove   ////////////////////////////////////////////

  bool checkInvProductsExist(prods) {
    bool invProdsExist = false;

    for (InvProd invProd in prods) {
      Product? foundProduct = prdCtr.productsList.firstWhere((product) => product.name == invProd.name, orElse: () => Product());
      if (foundProduct.name != '') {
        invProdsExist = true;
        print('## product<${foundProduct.name}> exist ');
      } else {
        showSnack('product<${foundProduct.name}> does not exist ', color: Colors.black54);
        print('## invoice products existance failed: product<${foundProduct.name}> doesnt exist');
        return false;
      }
    }
    return invProdsExist;
  }

  removeJustInv(Invoice inv) async {
    print('## start deleting just inv ....');

    try {
      //offline

      //online
      if (invOnlineRemove) {
        deleteDoc(
          docID: inv.id!,
          coll: invoicesColl,
        );
      }

      //----- success
      showSnack('${'invoice'.tr} "${inv.index}" ${'removed'.tr}', color: Colors.redAccent.withOpacity(0.8));
      print('## Invoice<${inv.id}> deleted alone ##');
    } catch (e) {
      print('## Error deleting just the inv<${inv.id}> : $e');
    }
  }

  removeInvoice(Invoice inv) async {
    await showNoHeader(
      txt: 'Are you sure you want to remove this invoice ?'.tr,
      icon: Icons.close,
      btnOkColor: Colors.red,
      btnOkText: 'Remove'.tr,
    ).then((toRemove) async {
      // if accept remove
      if (toRemove) {
        //if inv checked set back products qty of each one
        try {
          if (inv.verified!) {
            //ASK for undo prds qty in dialog
            bool undoQty = await showNoHeader(
              txt: 'Do you want to return the sold quantity ?'.tr,
              icon: Icons.history,
              btnOkColor: Colors.blueAccent,
              btnOkText: 'Get back'.tr,
            );

            if (undoQty) {
              List<InvProd> prods = invCtr.convertInvProdsMapToList(inv.productsReturned!); //convert prods map to InvProd list

              /// update each product in inv to return its qty

              if (checkInvProductsExist(prods)) {
                for (InvProd invProd in prods) {
                  Product? foundProduct = prdCtr.productsList.firstWhere((product) => product.name == invProd.name, orElse: () => Product());
                  await prdCtr.addReturnProc(
                    prod: foundProduct,
                    chosenQty: invProd.qty!,
                    invID: inv.id!,
                    isBuyInv: inv.isBuy!,
                    
                  );
                  //print('## inv<${inv.id}> : product<${foundProduct.name}>qty<${invProd.qty!}>  returned');
                }
              } else {
                print('## Failed to return qty: not all products in invoice exist NOW');
                throw Exception('## Exception ');
              }

              ///update societyCash (return)

              //with undo verified
              //Get.back();
            } else {
              //dont undo products qty //just remove
            }
          } else {
            //not verified
          }

          await removeJustInv(inv);

          ///Remove inv

          // ----- success
          print('## Invoice<${inv.id}> + prods (if with Undo)  deleted ##');
          refreshInvoices(withPrdsRefresh: true);
          update();
        } catch (e) {
          print('## Error deleting inv<${inv.id}> + products : $e');
        }
      }
    });
  }

  /// ////////////////////////////////////////////////////////////////////////////////////////

  /// convert Added Prods List
  // convert Map to List<invProdsList>
  List<InvProd> convertInvProdsMapToList(Map<String, dynamic>? productsRetunedOut) {
    List<InvProd> list = [];

    /// convert map to list

    list = productsRetunedOut!.entries.map((entry) {
      int index = int.tryParse(entry.key) ?? 0;
      Map<String, dynamic> jsonData = entry.value as Map<String, dynamic>;
      return InvProd.fromJson(jsonData);
    }).toList();
    return list;

    ///make changes to list (add/edit Prods) then conv to map
  }

  // convert List<invProdsList> to Map
  convertInvProdsListToMap() {
    ///convert list to map
    invProdsMap = invProdsList.asMap().map((index, invProd) {
      return MapEntry(index.toString(), invProd.toJson());
    });
  }

  /// //////////////////////////////////////////////////////////////////////////////////////////



}
