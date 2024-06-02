import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:phones_tracker/products/productsCtr.dart';
import 'package:phones_tracker/products/qrScan.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/bindings.dart';
import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

phonePropField({controller, label, bool enabled = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
    child: TextFormField(
      keyboardType: TextInputType.text,
      enabled: enabled,
      controller: controller,
      style: const TextStyle(
        fontSize: 18,
        color: normalTextCol,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        border: UnderlineInputBorder(),
        labelText: label,
        labelStyle: TextStyle(color: fillCol),
        focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: primaryColor)),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: dialogFieldEnableBorderCol)),
      ),
    ),
  );
}

imeiCtrTExt({
  controller,
  label,
  bool enabled = true,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
    child: TextFormField(
      keyboardType: TextInputType.text,
      enabled: enabled,
      controller: controller,
      style: const TextStyle(
        fontSize: 18,
        color: normalTextCol,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        border: UnderlineInputBorder(),
        labelText: label,
        labelStyle: TextStyle(color: fillCol),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: dialogFieldEnableBorderCol),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.qr_code),
          onPressed: () async {

            final result = await Get.to(QRScannerPage());
            if (result != null) {
              controller.text = result; // Set the scanned result to the controller
            }

          },
        ),
      ),
    ),
  );
}
class PhonePropertiesForm extends StatefulWidget {
  final bool isAdd;

  PhonePropertiesForm({required this.isAdd});

  @override
  _PhonePropertiesFormState createState() => _PhonePropertiesFormState();
}

class _PhonePropertiesFormState extends State<PhonePropertiesForm> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarBgColor,
        title: Text(
          widget.isAdd ? 'Add New Device'.tr : '${'Update'.tr} "${prdCtr.selectedProd.name}"',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: appBarTitleColor,
          ),
        ),
        bottom: appBarUnderline(),
      ),
      body: GetBuilder<ProductsCtr>(initState: (_) async {
        await Future.delayed(Duration(milliseconds: 200), () {

          if (!widget.isAdd) {
            //update

            prdCtr.getSelectedProdProps();
          } else {
            //add
            prdCtr.clearControllers();
          }
        });
      }, builder: (context) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        textAlign: TextAlign.start,
                        'Device info'.tr,
                        style: const TextStyle(
                          fontSize: 20,
                          color: orangeCol,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  //model + manuf
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Container(
                            width: 50.w,
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
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    showAnimDialog(prdCtr.ShowAddNewModel());
                                  },
                                  icon: Icon(Icons.add,color: orangeCol,), // Example icon
                                ),
                                focusColor: Colors.white,
                                fillColor: Colors.white,
                                hoverColor: Colors.white,
                                contentPadding: const EdgeInsets.only(bottom: 0, right: 0, left: 20),
                                // suffixIconConstraints: BoxConstraints(minWidth: 50,),
                                //  prefixIconConstraints: BoxConstraints(minWidth: 50),
                                //constraints:BoxConstraints(maxWidth: 20,maxHeight: 50) ,

                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(color: dialogFieldHintCol, fontSize: 14.5),

                                labelStyle: TextStyle(color: dialogFieldLabelCol, fontSize: 14.5),

                                errorStyle: TextStyle(
                                    color: dialogFieldErrorUnfocusBorderCol.withOpacity(.9), fontSize: 12, letterSpacing: 1),

                                enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: primaryColor)),
                                focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide(color: dialogFieldDisableBorderCol)),
                              ),
                              value: prdCtr.ModelTec,
                              items: modelValues.map((String v) {
                                return DropdownMenuItem<String>(
                                  value: v,
                                  child: Text(
                                    v,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {

                                    prdCtr.ModelTec = newValue!;

                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Container(
                            width: 30.w,
                            child: DropdownButtonFormField<String>(
                              style: TextStyle(color: dialogFieldWriteCol, fontSize: 14.5),
                              isExpanded: true,
                              dropdownColor: bgCol,
                              decoration: InputDecoration(
                                labelText: 'Brand',
                                filled: false,
                                isCollapsed: false,
                                isDense: true,
                                suffixIcon: IconButton(
                                  onPressed: () {

                                    showAnimDialog(prdCtr.ShowAddNewBrand());
                                  },
                                  icon: Icon(Icons.add,color: orangeCol,), // Example icon
                                ),
                                focusColor: Colors.white,
                                fillColor: Colors.white,
                                hoverColor: Colors.white,
                                contentPadding: const EdgeInsets.only(bottom: 0, right: 0, left: 0),
                                // suffixIconConstraints: BoxConstraints(minWidth: 50,),
                                //  prefixIconConstraints: BoxConstraints(minWidth: 50),
                                constraints: BoxConstraints(maxWidth: 20, maxHeight: 50),

                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(color: dialogFieldHintCol, fontSize: 14.5),

                                labelStyle: TextStyle(color: dialogFieldLabelCol, fontSize: 14.5),

                                errorStyle: TextStyle(
                                    color: dialogFieldErrorUnfocusBorderCol.withOpacity(.9), fontSize: 12, letterSpacing: 1),

                                enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: primaryColor)),
                                focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: BorderSide(color: dialogFieldDisableBorderCol)),
                              ),
                              value: prdCtr.manufacturerText,
                              items: phoneManufacturers.map((String wrkSpace) {
                                return DropdownMenuItem<String>(
                                  value: wrkSpace,
                                  child: Text(
                                    wrkSpace,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  prdCtr.manufacturerText = newValue!;
                                  // manufacturerController.text = newValue ?? '';
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 35,
                  ),
                  //ram + storage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Container(
                          width: 40.w,
                          child: DropdownButtonFormField<String>(
                            style: TextStyle(color: dialogFieldWriteCol, fontSize: 14.5),
                            dropdownColor: bgCol,
                            decoration: InputDecoration(
                              labelText: 'RAM',
                              filled: false,
                              isCollapsed: false,
                              isDense: true,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  showAnimDialog(prdCtr.ShowAddNewRAM());
                                },
                                icon: Icon(Icons.add,color: orangeCol,), // Example icon
                              ),
                              focusColor: Colors.white,
                              fillColor: Colors.white,
                              hoverColor: Colors.white,
                              contentPadding: const EdgeInsets.only(bottom: 0, right: 20, left: 20),
                              // suffixIconConstraints: BoxConstraints(minWidth: 50,),
                              //  prefixIconConstraints: BoxConstraints(minWidth: 50),
                              constraints: BoxConstraints(maxWidth: 20, maxHeight: 50),

                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintStyle: TextStyle(color: dialogFieldHintCol, fontSize: 14.5),

                              labelStyle: TextStyle(color: dialogFieldLabelCol, fontSize: 14.5),

                              errorStyle: TextStyle(
                                  color: dialogFieldErrorUnfocusBorderCol.withOpacity(.9), fontSize: 12, letterSpacing: 1),

                              enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: primaryColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(color: dialogFieldDisableBorderCol)),
                            ),
                            value: prdCtr.ramController,
                            items: ramValues.map((String wrkSpace) {
                              return DropdownMenuItem<String>(
                                value: wrkSpace,
                                child: Text(wrkSpace),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                prdCtr.ramController = newValue!;
                                // manufacturerController.text = newValue ?? '';
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Container(
                          width: 40.w,
                          child: DropdownButtonFormField<String>(
                            style: TextStyle(color: dialogFieldWriteCol, fontSize: 14.5),
                            dropdownColor: bgCol,
                            decoration: InputDecoration(
                              labelText: 'Storage',
                              filled: false,
                              isCollapsed: false,
                              isDense: true,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  showAnimDialog(prdCtr.ShowAddNewStorage());
                                },
                                icon: Icon(Icons.add,color: orangeCol,), // Example icon
                              ),
                              focusColor: Colors.white,
                              fillColor: Colors.white,
                              hoverColor: Colors.white,
                              contentPadding: const EdgeInsets.only(bottom: 0, right: 20, left: 20),
                              // suffixIconConstraints: BoxConstraints(minWidth: 50,),
                              //  prefixIconConstraints: BoxConstraints(minWidth: 50),
                              constraints: BoxConstraints(maxWidth: 20, maxHeight: 50),

                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintStyle: TextStyle(color: dialogFieldHintCol, fontSize: 14.5),

                              labelStyle: TextStyle(color: dialogFieldLabelCol, fontSize: 14.5),

                              errorStyle: TextStyle(
                                  color: dialogFieldErrorUnfocusBorderCol.withOpacity(.9), fontSize: 12, letterSpacing: 1),

                              enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: primaryColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(color: dialogFieldDisableBorderCol)),
                            ),
                            value: prdCtr.storageController,
                            items: storageValues.map((String wrkSpace) {
                              return DropdownMenuItem<String>(
                                value: wrkSpace,
                                child: Text(wrkSpace),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                prdCtr.storageController = newValue!;
                                // manufacturerController.text = newValue ?? '';
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 35,
                  ),

                  //color
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Container(
                          width: 40.w,
                          child: DropdownButtonFormField<String>(
                            style: TextStyle(color: dialogFieldWriteCol, fontSize: 14.5),
                            dropdownColor: bgCol,
                            decoration: InputDecoration(
                              labelText: 'Color',
                              filled: false,
                              isCollapsed: false,
                              isDense: true,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  showAnimDialog(prdCtr.ShowAddNewColor());
                                },
                                icon: Icon(Icons.add,color: orangeCol,), // Example icon
                              ),
                              focusColor: Colors.white,
                              fillColor: Colors.white,
                              hoverColor: Colors.white,
                              contentPadding: const EdgeInsets.only(bottom: 0, right: 20, left: 20),
                              // suffixIconConstraints: BoxConstraints(minWidth: 50,),
                              //  prefixIconConstraints: BoxConstraints(minWidth: 50),
                              constraints: BoxConstraints(maxWidth: 20, maxHeight: 50),

                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintStyle: TextStyle(color: dialogFieldHintCol, fontSize: 14.5),

                              labelStyle: TextStyle(color: dialogFieldLabelCol, fontSize: 14.5),

                              errorStyle: TextStyle(
                                  color: dialogFieldErrorUnfocusBorderCol.withOpacity(.9), fontSize: 12, letterSpacing: 1),

                              enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: primaryColor)),
                              focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: BorderSide(color: dialogFieldDisableBorderCol)),
                            ),
                            value: prdCtr.colorController,
                            items: colorValues.map((String wrkSpace) {
                              return DropdownMenuItem<String>(
                                value: wrkSpace,
                                child: Text(wrkSpace),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                prdCtr.colorController = newValue!;
                                // manufacturerController.text = newValue ?? '';
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 40.w,
                      )
                    ],
                  ),

                  SizedBox(
                    height: 25,
                  ),

                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        textAlign: TextAlign.start,
                        'Commerce info'.tr,
                        style: const TextStyle(
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                        textAlign: TextAlign.start,
                        'Quantities'.tr,
                        style: const TextStyle(
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
                        enabled: !cUser.isAdmin ? (workspace == cWs) : true,
                        icon: LineIcons.layerGroup,
                        textInputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'\d+')),
                        ],
                          onChanged:(txt){
                           prdCtr. initializeIMEIControllers(int.tryParse(txt)??0);
                          prdCtr.update();
                          },
                        validator: (value) {
                          int qty = 0;
                          try {
                            qty = int.parse(value!);
                          } catch (e) {
                           // prdCtr.qtyControllers[workspace]!.text='0';
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
                  SizedBox(height: 20),
                  if (widget.isAdd &&  int.tryParse(prdCtr.qtyControllers[cWs]!.text)!=null&&  int.tryParse(prdCtr.qtyControllers[cWs]!.text)!=0 ) ...[
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Text(
                          textAlign: TextAlign.start,
                          'IMEI Codes'.tr,
                          style: const TextStyle(
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
                    Column(
                      children: List.generate(
                          int.tryParse(prdCtr.qtyControllers[cWs]!.text)??0,
                          (index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),

                                child: imeiCtrTExt(label: 'Code IMEI for device n°${index+1}',        controller: prdCtr.imeiControllers[index], // Assuming you have a list of controllers
                                ),
                              )),
                    ),
                  ],

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
                        widget.isAdd ? "Add".tr : "Update".tr,
                        style: TextStyle(color: dialogBtnOkTextCol),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
