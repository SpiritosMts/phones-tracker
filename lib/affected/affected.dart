import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phones_tracker/_manager/bindings.dart';
import 'package:phones_tracker/products/productsCtr.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import '../_models/affectedDev.dart';
import 'affDtails.dart';

class AffectedDevices extends StatefulWidget {
  const AffectedDevices({super.key});

  @override
  State<AffectedDevices> createState() => _AffectedDevicesState();
}

class _AffectedDevicesState extends State<AffectedDevices> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarBgColor,
        title: Text('Deffected Devices',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: appBarTitleColor,
          ),
        ),
        bottom: appBarUnderline(),

      ),
      body: Container(
        color: bgCol,
        child: GetBuilder<ProductsCtr>(
            initState: (_) {

              prdCtr.refreshAffecteds();
            },
            builder: (_) {

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 20,),
                Expanded(
                  child: Container(
                    child:prdCtr.affetedDevs.isNotEmpty? ListView.builder(
                      //  physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 5,
                          bottom: 20,
                          right: 0,
                          left: 0,
                        ),
                        //itemExtent: 100,// card height
                        itemCount: prdCtr.affetedDevs.length,
                        itemBuilder: (BuildContext context, int index) {
                          AffectedDev req = (prdCtr.affetedDevs[index]);
                          if(req.wrkSpace==cWs || cUser.isAdmin){
                            return affectedCard(req, index);

                          }else{
                            return Container();
                          }

                        }
                    ):Padding(
                      padding: EdgeInsets.only(top: 35.h,left: 20.w),
                      child: Text('no Devices found', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                        textStyle:  TextStyle(
                            fontSize: 23  ,
                            color: elementNotFoundColor,
                            fontWeight: FontWeight.w700
                        ),
                      )),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        ),
      ),
      floatingActionButton:    FloatingActionButton(
        onPressed: () {
          Get.to(() => AffDetails(isAdd: true));

        },
        backgroundColor: primaryColor.withOpacity(0.8),
        heroTag: 'add seel',
        child: const Icon(Icons.add),
      ),
    );
  }
}
