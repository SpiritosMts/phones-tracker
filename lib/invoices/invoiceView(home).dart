import 'package:flutter/material.dart';
import 'package:phones_tracker/_manager/myUi.dart';
import 'package:phones_tracker/_models/invoice.dart';
import 'package:phones_tracker/invoices/invoiceCtr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../_manager/bindings.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';


class InvoicesView extends StatefulWidget {
  @override
  _InvoicesViewState createState() => _InvoicesViewState();
}

class _InvoicesViewState extends State<InvoicesView> {



  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgCol,

      child: GetBuilder<InvoicesCtr>(
          initState: (_) {},
          dispose: (_) {},
          builder: (_) {
            return (invCtr.invoicesList.isNotEmpty)
                ? ListView.builder(
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
                  return isDateToday(inv.timeReturn!) ? invCard(inv, index) : Container();
                })
                : elementNotFound('no invoices added yet'.tr);
          }),
    );
  }
}
