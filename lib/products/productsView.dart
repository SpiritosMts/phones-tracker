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

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  Widget productsList() {
    return Stack(
      children: [
        prdCtr.filteredProds.isNotEmpty
            ? AnimationLimiter(
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
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 20,
                        right: 0,
                        left: 0,
                      ),
                      itemCount: prdCtr.filteredProds.length,
                      itemBuilder: (BuildContext context, int index) {
                        Product prd = (prdCtr.filteredProds[index]);
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 200.0,
                            child: FadeInAnimation(
                              child: productCard(prd, index),
                            ),
                          ),
                        );
                      }),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: elementNotFound('no products found'.tr),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarBgColor,
        title: Text(
          'Inventory',
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
              Future.delayed(
                const Duration(milliseconds: 500),
                () {},
              );
            },
            dispose: (_) {},
            builder: (_) {
              return productsList();
            }),
      ),

    );
  }
}
