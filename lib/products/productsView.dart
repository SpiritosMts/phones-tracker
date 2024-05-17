import 'package:animations/animations.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:phones_tracker/_manager/bindings.dart';
import 'package:phones_tracker/_manager/myVoids.dart';
import 'package:phones_tracker/_models/product.dart';
import 'package:phones_tracker/main.dart';
import 'package:phones_tracker/products/productsCtr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/firebaseVoids.dart';
import '../_manager/myLocale/myLocaleCtr.dart';
import '../_manager/myUi.dart';
import '../_manager/styles.dart';

//########################################################################
//########################################################################

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});
  @override
  State<ProductsView> createState() => _ProductsViewState();
}
class _ProductsViewState extends State<ProductsView> {


  Widget productsList(){
    return AnimationLimiter(
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
    );
  }
  /// ######################################
  Widget builderWidget() {
    if(prdCtr.filteredProds.isEmpty) {
      return elementNotFound('no products added yet'.tr);
    }
    if(prdCtr.showList){

    }else{

    }
    return productsList();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgCol, //bg of products
      child: GetBuilder<ProductsCtr>(
          initState: (_) {
            Future.delayed(const Duration(milliseconds: 500), () {
              print('## open ProductsView ##');
            });
          },
          dispose: (_) {},
          builder: (_) {
            return builderWidget();
          }),
    );
  }
}
