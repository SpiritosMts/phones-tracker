import 'package:flutter/material.dart';
import 'package:phones_tracker/_models/invoice.dart';
import 'package:phones_tracker/invoices/invoiceCtr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/bindings.dart';
import '../_manager/myUi.dart';
import '../_manager/styles.dart';
import '../_models/product.dart';
class InvoicesHistory extends StatefulWidget {
  const InvoicesHistory({super.key});

  @override
  State<InvoicesHistory> createState() => _InvoicesHistoryState();
}

class _InvoicesHistoryState extends State<InvoicesHistory> {

  Map<String,dynamic> allItems = {};
  Map<String,dynamic> selectedMonthMap = {};
  List<Invoice> monthInvoices =[];

  String selectedMonth = '';

  double totalIncome = 0.0;
  double totalSell = 0.0;

  List<String> sellList =[];
  List<String> incomeList =[];
  List<String> timeList =[];

  List<double> incomes =[];
  List<double> totals =[];
  List<String> dates =[];
  List<Product> allProdsMonth=[];
  // /////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    allItems=invCtr.allItems;
    if(allItems.isNotEmpty) {
      selectMonth(allItems.keys.first);
    }

  }




  selectMonth(String month){
     debugPrint('## select: [$month] ');
     //debugPrint('## ${printFormattedJson(allItems[month])}');

    selectedMonth = month;

    selectedMonthMap ={};
    selectedMonthMap = Map.from(allItems[month]);
    totalIncome = selectedMonthMap['totalIncome']??0.0;
    totalSell = selectedMonthMap['totalSell']??0.0;

    //didnt use those
    // sellList = selectedMonthMap['sellList']??[];
    // incomeList = selectedMonthMap['incomeList']??[];
    // timeList = selectedMonthMap['timeList']??[];



    //remove these keys
    selectedMonthMap.remove('totalIncome');
    selectedMonthMap.remove('totalSell');

    selectedMonthMap.remove('sellList');
    selectedMonthMap.remove('incomeList');
    selectedMonthMap.remove('timeList');

    monthInvoices = selectedMonthMap.values.whereType<Invoice>().toList();
     totals = invCtr.extractTotals(monthInvoices.reversed.toList());
     incomes = invCtr.extractIncomes(monthInvoices.reversed.toList());
     dates = invCtr.extractDates(monthInvoices.reversed.toList());
    print('## select: [$month] => ${monthInvoices.length} INV ');

    // get top 5 products ////////////////////:
    //  List<double> totalSellList =[];
    //  List<double> totalIncomeList =[];
    //  List<int> totalQtyList =[];
    //  Map<String,dynamic> productsOrder ={};
     List<Product> allProds = prdCtr.productsList;
     allProdsMonth = [];
     for(int i = 0; i < allProds.length; i ++) {
       Map<String, dynamic> allItemsProd = allProds[i].allItems;

       if(allItemsProd.containsKey(month)){
         allProdsMonth.add(allProds[i]);
         // double prodTotal = allItemsProd[month]['totalSell']??0.0;
         // double prodIncome = allItemsProd[month]['totalIncome']??0.0;
         // int prodSelledQty = allItemsProd[month]['totalSelledQty']??0;

         //print('## ${allProds[i].name}: qty=  $prodSelledQty');

         // totalSellList.add(prodTotal);
         // totalIncomeList.add(prodIncome);
         // totalQtyList.add(prodSelledQty);
       }
     }
     allProdsMonth.sort((a, b) => (b.allItems[month]['totalSell'] ?? 0.0)
         .compareTo(a.allItems[month]['totalSell'] ?? 0.0));

     // List<double> totalss = [];
     // for (Product prd in allProdsMonth) {
     //   if (prd.allItems[month]['totalSell'] != null) {
     //     totalss.add(prd.allItems[month]['totalSell']!);
     //   }
     // }

     // 3 list choose order by what
     // totalSellList = sortDescending(totalSellList);
     // totalIncomeList = sortDescending(totalIncomeList);
     // totalQtyList = sortDescendingInt(totalQtyList);


     print('## [${allProds.length} all_PRODS]: [${allProds.length} ($month)_PRODS]:// ');



     }


  //#########################################################################
  //#########################################################################

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,/// tab length
      child: Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          elevation: 4,
          //backgroundColor: appbarColor,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Text('History',
                textAlign: TextAlign.center,
                ),
          ),
          actions: <Widget>[
            GetBuilder<InvoicesCtr>(
              //id:'appBar',
                builder: (_) {
                  //&& chCtr.selectedServer != ''
                  return allItems.isNotEmpty ? Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: DropdownButton<String>(
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: Container(),
                      dropdownColor:dropDownCol ,
                      // value:(gc.selectedServer!='' && gc.myPatients.isNotEmpty)? gc.myPatients[gc.selectedServer]!.name : 'no patients',
                      value: selectedMonth,
                      //value:'name',
                      items: allItems.keys.map((String month) {
                        return DropdownMenuItem<String>(
                          value: month,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                month,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (month) {
                        if(month != selectedMonth){
                          selectMonth(month!);

                          Future.delayed(const Duration(milliseconds: 200), () {
                            setState(() {});
                          });
                        }


                      },
                    ),
                  )
                      : Container();
                }),
          ],
        ),
        body:     (selectedMonthMap.isNotEmpty) ? ListView.builder(
          //physics: const NeverScrollableScrollPhysics(),
          //itemExtent: 130,
            padding: const EdgeInsets.only(top: 5,bottom:60, right: 15, left: 15,),
            shrinkWrap: true,
            reverse: false,
            itemCount: selectedMonthMap.length,
            itemBuilder: (BuildContext context, int index) {
              String key = selectedMonthMap.keys.elementAt(index);

              //Invoice inv = Invoice.fromJson(selectedMonthMap[key]);
              return invCard(selectedMonthMap[key],int.parse(key));


            }
        ):Padding(
          padding: EdgeInsets.only(top: 35.h),
          child: Text('no Invoices found'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
            textStyle:  TextStyle(
                fontSize: 23  ,
                color: Colors.white,
                fontWeight: FontWeight.w700
            ),
          )),
        ),
        //##########################################################################
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      ),
    );
  }
}
