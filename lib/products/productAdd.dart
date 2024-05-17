import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phones_tracker/products/productsCtr.dart';

import '../_manager/bindings.dart';
import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import 'productsCtr.dart';

class PhonePropertiesForm extends StatefulWidget {
  final bool isAdd;
  PhonePropertiesForm({required this.isAdd});

  @override
  _PhonePropertiesFormState createState() => _PhonePropertiesFormState();
}

class _PhonePropertiesFormState extends State<PhonePropertiesForm> {


  phonePropField({required controller,label,bool enabled =true}){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      child: TextFormField(

        keyboardType: TextInputType.text,
enabled: enabled,
        controller: controller,
        style:const TextStyle(
          fontSize: 18,
          color: normalTextCol,

        ),
        decoration:  InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          border: UnderlineInputBorder(),
          labelText: label,
          labelStyle: TextStyle(
              color: fillCol
          ),

          focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: primaryColor)),
          enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: dialogFieldEnableBorderCol)),

        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarBgColor,
        title: Text(
          widget.isAdd?'Add New Device'.tr:'${'Update'.tr} "${prdCtr.selectedProd.name}"',
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

               prdCtr.getSelectedProdProps();


             }
             else{//add
               prdCtr.clearControllers();
             }
            });

          },

        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: prdCtr.addProductKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child:  Text(
                          textAlign: TextAlign.start,
                          'Device info'.tr,
                          style:const TextStyle(
                            fontSize: 20,
                            color: orangeCol,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),


                    phonePropField(
                      controller: prdCtr.nameTec,
                      label: 'Model',
                      enabled: widget.isAdd
                    ),
                    DropdownButtonFormField<String>(
                      style: TextStyle(color: dialogFieldWriteCol, fontSize: 14.5),

                      dropdownColor: bgCol,
                      decoration: InputDecoration(
                        labelText: 'Manufacturer',
                        filled: false,
                        isCollapsed: false,

                        focusColor:  Colors.white,
                        fillColor:  Colors.white,
                        hoverColor: Colors.white,
                        contentPadding: const EdgeInsets.only(bottom: 0, right: 20, left: 20),
                        suffixIconConstraints: BoxConstraints(minWidth: 50),
                        prefixIconConstraints: BoxConstraints(minWidth: 50),

                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,

                        hintStyle: TextStyle(color: dialogFieldHintCol, fontSize: 14.5),

                        labelStyle: TextStyle(color: dialogFieldLabelCol, fontSize: 14.5),

                        errorStyle: TextStyle(color: dialogFieldErrorUnfocusBorderCol.withOpacity(.9), fontSize: 12, letterSpacing: 1),

                        enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: primaryColor)),
                        focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: dialogFieldDisableBorderCol)),

                      ),
                      value: prdCtr.manufacturerText,
                      items: phoneManufacturers.map((String wrkSpace) {
                        return DropdownMenuItem<String>(
                          value: wrkSpace,
                          child: Text(wrkSpace),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          prdCtr.manufacturerText = newValue!;
                          // manufacturerController.text = newValue ?? '';
                        });
                      },
                    ),

                    phonePropField(
                      controller:prdCtr. brandController,
                      label: 'Brand',
                    ),
                    phonePropField(
                      controller: prdCtr.imeiController,
                      label:  'IMEI',
                    ),
                    phonePropField(
                      controller: prdCtr.colorController,
                      label: 'Color',
                    ),
                    phonePropField(
                      controller: prdCtr.batteryCapacityController,
                      label: 'Battery Capacity',
                    ),
                    phonePropField(
                      controller: prdCtr.resolutionController,
                      label:  'Resolution',
                    ),
                    phonePropField(
                      controller: prdCtr.ramController,
                      label:  'RAM',
                    ),
                    phonePropField(
                      controller: prdCtr.storageController,
                      label: 'Storage',
                    ),
                    phonePropField(
                      controller: prdCtr.weightController,
                      label:  'Weight',
                    ),



                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child:  Text(
                          textAlign: TextAlign.start,
                          'Commerce info'.tr,
                          style:const TextStyle(
                            fontSize: 20,
                            color: orangeCol,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 18,
                    ),
                    customTextField(
                      textInputType: TextInputType.number,
                      controller: prdCtr.sellPriceTec,
                      labelText: 'sell Price'.tr,
                      hintText: ''.tr,
                      icon: Icons.attach_money,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                      ],
                      validator: (value) {

                        if (value!.isEmpty) {
                          return "enter a price".tr;
                        }


                        return null;
                      },
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    /// buy price
                    customTextField(
                      textInputType: TextInputType.number,
                      controller: prdCtr.buyPriceTec,
                      labelText: 'buy Price'.tr,
                      hintText: ''.tr,
                      icon: Icons.attach_money,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                      ],
                      validator: (value) {

                        if (value!.isEmpty) {
                          return "enter a price".tr;
                        }


                        return null;
                      },
                    ),
                    /// ///////////////////////////// QUANTITIES /////////////////////////////////////////////
                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,

                      child: Container(
                        padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child:  Text(
                          textAlign: TextAlign.start,
                          'Quantities'.tr,
                          style:const TextStyle(
                            fontSize: 20,
                            color: orangeCol,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 18,
                    ),

                    ...workSpaces.map((workspace) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: customTextField(
                          controller: prdCtr.qtyControllers[workspace]!,
                          labelText: workspace,
                          hintText: ''.tr,
                          enabled: !cUser.isAdmin? (workspace==cWs) :true,
                          icon: LineIcons.layerGroup,
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                          ],
                          validator: (value) {
                            int qty = 0;
                            try {
                              qty = int.parse(value!);
                            } catch (e) {
                              qty = 0;
                            }
                            if (value!.isEmpty) {
                              return "Enter a quantity".tr;
                            }
                            return null;
                          },
                        ),
                      );
                    }),

                    /// ///////////////////////////// ADD BTN /////////////////////////////////////////////
                    SizedBox(height: 40),
                    SizedBox(
                      width: 100,
                      child: TextButton(

                        style: filledBtnStyle(),
                        onPressed: () async {
                          if (widget.isAdd) {
                            prdCtr.addProduct();
                          } else {
                            prdCtr.updateProductWithManualChange();

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

