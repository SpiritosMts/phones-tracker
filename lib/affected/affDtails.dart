import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/bindings.dart';
import '../_manager/styles.dart';
import '../_models/affectedDev.dart';
import '../products/productAdd.dart';
import '../products/productsCtr.dart';

class AffDetails extends StatefulWidget {
  final bool isAdd;

  const AffDetails({super.key,required this.isAdd});

  @override
  State<AffDetails> createState() => _AffDetailsState();
}

class _AffDetailsState extends State<AffDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarBgColor,
        title: Text(
          'Affected Device info',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: appBarTitleColor,
          ),
        ),
        bottom: appBarUnderline(),

      ),

      body:  GetBuilder<ProductsCtr>(

          initState: (_) async {
            await Future.delayed( Duration(milliseconds: 200), () {
              if (!widget.isAdd) {//update

                prdCtr.getAffSelectedProdProps();


              }
              else{//add
                prdCtr.clearAffControllers();
              }
            });

          },

          builder: (context) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: prdCtr.addAffKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child:  Text(
                            textAlign: TextAlign.start,
                            'Enter info'.tr,
                            style:const TextStyle(
                              fontSize: 20,
                              color: orangeCol,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),


                      SizedBox(height: 20,),

                      //model + color
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Container(
                                width: 60.w,
                                child: DropdownButtonFormField<String>(
                                  alignment: AlignmentDirectional.centerStart,
                                  isExpanded: true,
                                  style: TextStyle(color: dialogFieldWriteCol, fontSize: 13),

                                  dropdownColor: bgCol,
                                  decoration: InputDecoration(
                                    labelText: 'Model',
                                    filled: false,
                                    isCollapsed: false,
                                    isDense: true,

                                    focusColor:  Colors.white,
                                    fillColor:  Colors.white,
                                    hoverColor: Colors.white,
                                    contentPadding: const EdgeInsets.only(bottom: 0, right: 0, left: 20),
                                    // suffixIconConstraints: BoxConstraints(minWidth: 50,),
                                    //  prefixIconConstraints: BoxConstraints(minWidth: 50),
                                    //constraints:BoxConstraints(maxWidth: 20,maxHeight: 50) ,

                                    border: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintStyle: TextStyle(color: dialogFieldHintCol, fontSize: 14.5),

                                    labelStyle: TextStyle(color: dialogFieldLabelCol, fontSize: 14.5),

                                    errorStyle: TextStyle(color: dialogFieldErrorUnfocusBorderCol.withOpacity(.9), fontSize: 12, letterSpacing: 1),

                                    enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: primaryColor)),
                                    focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldDisableBorderCol)),

                                  ),
                                  value: prdCtr.modelAff,
                                  items: modelValues.map((String v) {
                                    return DropdownMenuItem<String>(

                                      value: v,
                                      child: Text(v,style: TextStyle(fontSize: 13),),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      prdCtr.modelAff = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Container(
                                width: 20.w,
                                child: DropdownButtonFormField<String>(
                                  style: TextStyle(color: dialogFieldWriteCol, fontSize: 14.5),
                                  isExpanded: true,

                                  dropdownColor: bgCol,
                                  decoration: InputDecoration(
                                    labelText: 'State',
                                    filled: false,
                                    isCollapsed: false,
                                    isDense: true,

                                    focusColor:  Colors.white,
                                    fillColor:  Colors.white,
                                    hoverColor: Colors.white,
                                    contentPadding: const EdgeInsets.only(bottom: 0, right: 0, left: 0),
                                    // suffixIconConstraints: BoxConstraints(minWidth: 50,),
                                    //  prefixIconConstraints: BoxConstraints(minWidth: 50),
                                    constraints:BoxConstraints(maxWidth: 20,maxHeight: 50) ,

                                    border: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintStyle: TextStyle(color: dialogFieldHintCol, fontSize: 14.5),

                                    labelStyle: TextStyle(color: dialogFieldLabelCol, fontSize: 14.5),

                                    errorStyle: TextStyle(color: dialogFieldErrorUnfocusBorderCol.withOpacity(.9), fontSize: 12, letterSpacing: 1),

                                    enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: primaryColor)),
                                    focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldDisableBorderCol)),

                                  ),
                                  value: prdCtr.stateAff,
                                  items: statesAff.map((String wrkSpace) {
                                    return DropdownMenuItem<String>(
                                      value: wrkSpace,
                                      child: Text(wrkSpace,style: TextStyle(fontSize: 11),),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      prdCtr.stateAff = newValue!;
                                      // manufacturerController.text = newValue ?? '';
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),


                      phonePropField(
                        controller: prdCtr.affClientTec,
                        label:  'Client Name',
                        enabled: widget.isAdd
                      ),
                      imeiCtrTExt(
                        controller: prdCtr.imeiAffController,
                        label:  'IMEI',
                      ),
                      phonePropField(
                        controller: prdCtr.descAffController,
                        label: 'Description',
                      ),




                      /// ///////////////////////////// ADD BTN /////////////////////////////////////////////
                      SizedBox(height: 40),
                      SizedBox(
                        width: 100,
                        child: TextButton(

                          style: filledBtnStyle(),
                          onPressed: () async {
                            if (widget.isAdd) {
                              prdCtr.addAff();
                            } else {
                              prdCtr.updateAff();

                            }
                          },
                          child: Text(
                            widget.isAdd? "Add".tr:"Update".tr,
                            style: TextStyle(
                                color: dialogBtnOkTextCol),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
