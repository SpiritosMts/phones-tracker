import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:phones_tracker/_manager/bindings.dart';
import 'package:phones_tracker/_models/product.dart';
import 'package:phones_tracker/products/productsCtr.dart';
import 'package:get/get.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/myUi.dart';
import '../_manager/styles.dart';
import 'productsView.dart';

//########################################################################
//########################################################################

class SearchProductsView extends StatefulWidget {
  const SearchProductsView({super.key});
  @override
  State<SearchProductsView> createState() => _SearchProductsViewState();
}
class _SearchProductsViewState extends State<SearchProductsView> {


  Widget productsList(){
    return  Stack(
      children: [
        prdCtr.filteredProds.isNotEmpty? AnimationLimiter(
          child: CustomMaterialIndicator(
            withRotation: true,
            onRefresh: () async {
              prdCtr.refreshProducts();
            },
            indicatorBuilder: (context, controller) {
              return Icon(
                Icons.downloading_outlined,
                color: Colors.blue,
                size: 30,
              );
            },
            child: ListView.builder(
              //  physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 20,
                  right: 0,
                  left: 0,
                ),
                //itemExtent: 100,// card height
                itemCount: prdCtr.filteredProds.length,
                itemBuilder: (BuildContext context, int index) {
                  Product prd = (prdCtr.filteredProds[index]);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 200.0,//how to be animated came from bottom
                      child: FadeInAnimation(
                        child: productCard(prd, index),
                      ),
                    ),
                  );
                }),
          ),
        ):Padding(padding: EdgeInsets.only(left: 25.w),child: elementNotFound('no products found'.tr),),
        Positioned(
          bottom: 0,
          right: 15,
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0, right: 0, left: 0),

            child: ElevatedButton(
              style: filledBtnStyle(),
              onPressed: () {
              /// RUN FILTER *******************************************************
              },
              child: Text(
                 "Search".tr,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
  /// ######################################


  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgCol, //bg of products
      child: GetBuilder<ProductsCtr>(
          initState: (_) {
            Future.delayed(const Duration(milliseconds: 500), () {
              prdCtr.searchModelTec=modelValues[0];
              prdCtr.searchstorageController=storageValues[0];
              prdCtr.searchcolorController= colorValues[0];
              prdCtr.searchramController=ramValues[0];
            prdCtr.update();
            });
          },
          dispose: (_) {},
          builder: (_) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                // key: prdCtr.addProductKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child:  Text(
                            textAlign: TextAlign.start,
                            'Filter By:'.tr,
                            style:const TextStyle(
                              fontSize: 20,
                              color: orangeCol,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),



                      SizedBox(height: 35,),

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
                                  value: prdCtr.searchModelTec,
                                  items: modelValues.map((String v) {
                                    return DropdownMenuItem<String>(

                                      value: v,
                                      child: Text(v,style: TextStyle(fontSize: 13),),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      prdCtr.searchModelTec = newValue!;
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
                                    labelText: 'Color',
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
                                  value: prdCtr.searchcolorController,
                                  items: colorValues.map((String wrkSpace) {
                                    return DropdownMenuItem<String>(
                                      value: wrkSpace,
                                      child: Text(wrkSpace),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      prdCtr.searchcolorController = newValue!;
                                      // manufacturerController.text = newValue ?? '';
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 45,),
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
                                isExpanded: true,

                                dropdownColor: bgCol,
                                decoration: InputDecoration(
                                  labelText: 'RAM',
                                  filled: false,
                                  isCollapsed: false,
                                  isDense: true,

                                  focusColor:  Colors.white,
                                  fillColor:  Colors.white,
                                  hoverColor: Colors.white,
                                  contentPadding: const EdgeInsets.only(bottom: 0, right: 20, left: 20),
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
                                value: prdCtr.searchramController,
                                items: ramValues.map((String wrkSpace) {
                                  return DropdownMenuItem<String>(
                                    value: wrkSpace,
                                    child: Text(wrkSpace),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    prdCtr.searchramController = newValue!;
                                    // manufacturerController.text = newValue ?? '';
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Container(
                              width: 40.w,
                              child: DropdownButtonFormField<String>(
                                style: TextStyle(color: dialogFieldWriteCol, fontSize: 14.5),
                                isExpanded: true,

                                dropdownColor: bgCol,
                                decoration: InputDecoration(
                                  labelText: 'Storage',
                                  filled: false,
                                  isCollapsed: false,
                                  isDense: true,

                                  focusColor:  Colors.white,
                                  fillColor:  Colors.white,
                                  hoverColor: Colors.white,
                                  contentPadding: const EdgeInsets.only(bottom: 0, right: 20, left: 20),
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
                                value: prdCtr.searchstorageController,
                                items: storageValues.map((String wrkSpace) {
                                  return DropdownMenuItem<String>(
                                    value: wrkSpace,
                                    child: Text(wrkSpace),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    prdCtr.searchstorageController = newValue!;
                                    // manufacturerController.text = newValue ?? '';
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 35,),

                      SizedBox(height: 40),
                      SizedBox(
                        width: 100,
                        child: TextButton(

                          style: filledBtnStyle(),
                          onPressed: () async {

                           // prdCtr.addFieldToArrayInFirestore();
                            prdCtr.runProdFilter(byFilter: true);
                            Get.to(()=>ProductsView());

                            // prdCtr.addFieldToArrayInFirestore( [
                            //   'Pixel 4a', 'Pixel 5', 'Pixel 6', 'Pixel 7','Mi 11', 'Redmi Note 10', 'Mi 10T', 'Poco X3',
                            //   'iPhone 12', 'iPhone 11', 'iPhone SE', 'iPhone XR','Galaxy S21', 'Galaxy A52', 'Galaxy Note 20', 'Galaxy Z Fold 3',
                            //   'P40', 'Mate 40', 'P30', 'Nova 7','OnePlus 8', 'OnePlus 9', 'OnePlus Nord', 'OnePlus 7T',
                            //   'Xperia 5', 'Xperia 1', 'Xperia 10', 'Xperia L4','G8 ThinQ', 'V60 ThinQ', 'Velvet', 'Wing','Nokia 8.3', 'Nokia 5.3', 'Nokia 7.2', 'Nokia 6.2'
                            // ]);
                           // prdCtr.addProductsToFirestore();
                          },
                          child: Text(
                            "Search",
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
          },
      ),
    );
  }
}
