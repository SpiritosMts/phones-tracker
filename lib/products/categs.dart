import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:phones_tracker/_manager/bindings.dart';
import 'package:phones_tracker/_models/product.dart';
import 'package:phones_tracker/products/productAdd.dart';
import 'package:phones_tracker/products/productsCtr.dart';
import 'package:get/get.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import 'productsView.dart';

class Categs extends StatefulWidget {
  const Categs({super.key});

  @override
  State<Categs> createState() => _CategsState();
}

class _CategsState extends State<Categs> {
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
        actions: [
          IconButton(
            onPressed: () {
              prdCtr.runProdFilter(showAll: true);
              Get.to(() => ProductsView());
            },
            icon: Icon(
              Icons.clear_all_sharp,
              color: appBarButtonsCol,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: appBarBgColor,
        title: Text(
          'Brands',
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: phoneManufacturers.length,
                  itemBuilder: (context, index) {
                    String manufacturer = phoneManufacturers[index];
                    String imagePath = 'assets/images/phone-logos/brand.png';
                    bool imageFound = false;
                    if (StaticPhoneManufacturers.contains(manufacturer)) {
                      imagePath = 'assets/images/phone-logos/$manufacturer.png';
                      imageFound = true;
                    }
                    return GestureDetector(
                      onTap: () {
                        prdCtr.selectedManufac = manufacturer;
                        prdCtr.runProdFilter(manu: manufacturer);
                        showSnack('$manufacturer Devices ...');
                        Get.to(() => ProductsView());

                        Future.delayed(const Duration(milliseconds: 200), () {
                          prdCtr.update();
                        });
                      },
                      child: GridTile(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                        footer: SizedBox(
                          height: 18,
                          child: GridTileBar(
                            title: Text(
                              manufacturer,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: filledBtnStyle(),
          onPressed: () {
            Get.to(() => PhonePropertiesForm(
                  isAdd: true,
                ));
          },
          child: Text(
            "Add Device".tr,
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
