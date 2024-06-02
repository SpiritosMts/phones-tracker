

import 'package:get/get.dart';

import '../invoices/invoiceCtr.dart';
import '../notes/notesCtr.dart';
import '../products/productsCtr.dart';
import 'auth/authCtr.dart';
import 'generalLayout/generalLayoutCtr.dart';
import 'myLocale/myLocaleCtr.dart';


AuthController authCtr = AuthController.instance;

LayoutCtr get layCtr => Get.find<LayoutCtr>();

InvoicesCtr get invCtr => Get.find<InvoicesCtr>();
ProductsCtr get prdCtr => Get.find<ProductsCtr>();
MyLocaleCtr get lngCtr => Get.find<MyLocaleCtr>();
NotesCtr get noteCtr => Get.find<NotesCtr>();



///PatientsListCtr get patListCtr => Get.find<PatientsListCtr>(); //default


class GetxBinding implements Bindings {
  @override
  void dependencies() {
    //TODO

    Get.put<AuthController>(AuthController());


    Get.lazyPut<LayoutCtr>(() => LayoutCtr(),fenix: true);
    Get.lazyPut<NotesCtr>(() => NotesCtr(),fenix: true);
    Get.lazyPut<InvoicesCtr>(() => InvoicesCtr(),fenix: true);
    Get.lazyPut<ProductsCtr>(() => ProductsCtr(),fenix: true);
   //Get.lazyPut<InvoicesCtr>(() => InvoicesCtr(),fenix: true);


    //print("## getx dependency injection completed (Get.put() )");

  }
}