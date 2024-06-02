import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:phones_tracker/_manager/myUi.dart';
import 'package:phones_tracker/_models/invoice.dart';
import 'package:phones_tracker/invoices/invoiceCtr.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../_manager/bindings.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import 'addEditInvoice.dart';

class InvoicesView extends StatefulWidget {
  @override
  _InvoicesViewState createState() => _InvoicesViewState();
}

class _InvoicesViewState extends State<InvoicesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarBgColor,
        title: Text(
          'Invoices',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: appBarTitleColor,
          ),
        ),
        bottom: appBarUnderline(),
      ),
      body: Container(
        color: bgCol,
        child: GetBuilder<InvoicesCtr>(
            initState: (_) {},
            dispose: (_) {},
            builder: (_) {
              return (invCtr.invoicesList.isNotEmpty)
                  ? CustomMaterialIndicator(
                      withRotation: true,
                      onRefresh: () async {
                        invCtr.refreshInvoices(withPrdsRefresh: true);
                      },
                      indicatorBuilder: (context, controller) {
                        return Icon(
                          Icons.downloading_outlined,
                          color: Colors.blue,
                          size: 30,
                        );
                      },
                      child: ListView.builder(
                          //physics: const NeverScrollableScrollPhysics(),
                          //itemExtent: 180,
                          reverse: false,
                          padding: const EdgeInsets.only(
                            top: 5,
                            bottom: 60,
                            right: 15,
                            left: 15,
                          ),
                          shrinkWrap: true,
                          itemCount: invCtr.invoicesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Invoice inv = (invCtr.invoicesList[index]);
                            // return isDateToday(inv.timeReturn!) ? invCard(inv, index) : Container();//return of today
                            if (inv.workSpace == cWs || cUser.isAdmin) {
                              return invCard(inv, index); //of all days
                            } else {
                              return Container();
                            }
                          }),
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: 25.w),
                      child: elementNotFound('no invoices added yet'.tr),
                    );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('## add NEW sell invoice');
          if (prdCtr.productsList.isEmpty) {
            showSnack('You have to register at least one product to add sell invoice'.tr, color: snackBarError);
            return;
          }
          invCtr.invType = 'Multiple';
          Get.to(() => AddEditInvoice(), arguments: {
            'isAdd': true,
            'isVerified': false,
            'isBuy': false,
          });
        },
        backgroundColor: primaryColor.withOpacity(0.8),
        heroTag: 'add seel',
        child: const Icon(Icons.add),
      ),
    );
  }
}
