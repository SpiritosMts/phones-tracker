

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:phones_tracker/_manager/bindings.dart';
import 'package:phones_tracker/_models/prodChange.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../_manager/firebaseVoids.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import '../_models/buySellProd.dart';
import '../_models/note.dart';
import '../_models/product.dart';
import '../main.dart';
import 'addBSProdDialog.dart';
import 'addProductDialog.dart';
import 'package:uuid/uuid.dart';



List<String> phoneManufacturers = [
  'Apple',
  'Samsung',
  'Huawei',
  'Xiaomi',
  'OnePlus',
  'Google',
  'Sony',
  'LG',
  'Nokia',
];
List<String> workSpaces = [
  'Sousse',
  'Monastir',
  'Nabeul',
  'Tunis',
];
class ProductsCtr extends GetxController {

  void addProductsToFirestore() async {

    final Map<String, List<String>> models = {
      'Google': ['Pixel 4a', 'Pixel 5', 'Pixel 6', 'Pixel 7'],
      'Xiaomi': ['Mi 11', 'Redmi Note 10', 'Mi 10T', 'Poco X3'],
      'Apple': ['iPhone 12', 'iPhone 11', 'iPhone SE', 'iPhone XR'],
      'Samsung': ['Galaxy S21', 'Galaxy A52', 'Galaxy Note 20', 'Galaxy Z Fold 3'],
      'Huawei': ['P40', 'Mate 40', 'P30', 'Nova 7'],
      'OnePlus': ['OnePlus 8', 'OnePlus 9', 'OnePlus Nord', 'OnePlus 7T'],
      'Sony': ['Xperia 5', 'Xperia 1', 'Xperia 10', 'Xperia L4'],
      'LG': ['G8 ThinQ', 'V60 ThinQ', 'Velvet', 'Wing'],
      'Nokia': ['Nokia 8.3', 'Nokia 5.3', 'Nokia 7.2', 'Nokia 6.2']
    };
    final List<String> colors = [
      'Red',
      'Blue',
      'Green',
      'Black',
      'White',
      'Gray',
      'Yellow',
      'Purple',
      'Pink',
      'Orange'
    ];

    final random = Random();

    for (String manufacturer in phoneManufacturers) {
      for (String model in models[manufacturer]!) {
        double currBuyPrice = 200000 + random.nextInt(1800000).toDouble();
        double currPrice = currBuyPrice + random.nextInt((2000000 - currBuyPrice.toInt())).toDouble();
        Map<String, int> currQty = {
          for (String workspace in workSpaces) workspace: random.nextInt(200)
        };
        String randomColor = colors[random.nextInt(colors.length)];

        String specificID = '${model} -ID';

        await addDocument(
          fieldsMap: {
            'name': model,
            'manufacturer': manufacturer,
            'brand': manufacturer,
            'imei': 'IMEI_${random.nextInt(999999999999999 % (10^15))}',
            'color': randomColor,
            'batteryCapacity': '${random.nextInt(4000) + 1000}mAh',
            'resolution': '${random.nextInt(1080) + 720}p',
            'ram': '${random.nextInt(12) + 1}GB',
            'storage': '${random.nextInt(512) + 64}GB',
            'weight': '${random.nextInt(300) + 100}g',
            'currPrice': currPrice,
            'currBuyPrice': currBuyPrice,
            'currQty': currQty,
            'addedTime': DateTime.now().toIso8601String(),
            'prodChanges': {},
            'buyHis': {},
            'sellHis': {},
          },
          coll  : productsColl,
          specificID: specificID,
        );

      }
    }
  }


  bool showList = true;



  bool isSell =true;
  String productListKey = 'productsList';//if change it, it wont get prods again
  int otherMonthInfoLength =9;

  String selectedManufac = phoneManufacturers[0];
  List<Product>  productsList= [];//all products
  List<Product>  filteredProds= [];//filtered products
  List<String>  productsNames= [];//names of all products
  Product selectedProd = Product();
  void selectProduct(Product prd){
    selectedProd = prd;
    printMapLength();
  }
  void printMapLength( ) {
    debugPrint('## select < ${selectedProd.name} >  (sellHis(${selectedProd.sellHis.length}) /buyHis(${selectedProd.buyHis.length}) /prodChanges(${selectedProd.prodChanges.length}) /) ');

    print('## allItems(months numbers): (${selectedProd.allItems.length})');
    int total =0;
    selectedProd.allItems.forEach((key, value) {//each month
      int monthTotal =value.length-otherMonthInfoLength;
      print('       - $key: ($monthTotal)');
      total += monthTotal;
    });
    print('       --- all: ($total) ---');

  }
  Map<String, int> getCurrQtyFromControllers() {
    List<TextEditingController> controllers = qtyControllers.values.toList();

    Map<String, int> currQty = {};
    for (int i = 0; i < workSpaces.length; i++) {
      currQty[workSpaces[i]] = int.tryParse(controllers[i].text) ?? 0;
    }
    return currQty;
  }


  final searchTec = TextEditingController();


  /// add product
  GlobalKey<FormState> addProductKey = GlobalKey<FormState>();
  final nameTec = TextEditingController();
  String manufacturerText = phoneManufacturers[0];
  final brandController = TextEditingController();
  final imeiController = TextEditingController();
  final colorController = TextEditingController();
  final batteryCapacityController = TextEditingController();
  final resolutionController = TextEditingController();
  final ramController = TextEditingController();
  final storageController = TextEditingController();
  final weightController = TextEditingController();
  final sellPriceTec = TextEditingController();
  final buyPriceTec = TextEditingController();
  //final qtyTec = TextEditingController();
  Map<String, TextEditingController> qtyControllers = {};



  //######################################################################################################"


  late SwipeActionController prodsSwipeCtr;
  late SwipeActionController prodsHistorySwipeCtr;

  void clearControllers() {
    nameTec.clear();
    manufacturerText = phoneManufacturers[0];
    brandController.clear();
    imeiController.clear();
    colorController.clear();
    batteryCapacityController.clear();
    resolutionController.clear();
    ramController.clear();
    storageController.clear();
    weightController.clear();
    sellPriceTec.clear();
    buyPriceTec.clear();
    //qtyTec.clear();
    qtyControllers = {
      for (var workspace in workSpaces) workspace: TextEditingController(text: '0')
    };
    update();

  }

  runProdFilter({String manu ='',String searchText ='',bool showAll =false,}){
    //show all
    // how to get from List<Product> only products with manufactur == 'apple'
    if(manu.isNotEmpty) {
      filteredProds = productsList.where((product) => product.manufacturer?.toLowerCase() == manu.toLowerCase()).toList();
    }

    if(searchText.isNotEmpty){
      filteredProds = productsList.where((product) {
        return
          (product.name?.toLowerCase().contains(searchText.toLowerCase()) ?? false) ||
          //  (product.manufacturer?.toLowerCase().contains(searchText.toLowerCase()) ?? false) ||
            (product.brand?.toLowerCase().contains(searchText.toLowerCase()) ?? false) ||
            (product.imei?.toLowerCase().contains(searchText.toLowerCase()) ?? false) ||
            (product.color?.toLowerCase().contains(searchText.toLowerCase()) ?? false) ||
            (product.batteryCapacity?.toLowerCase().contains(searchText.toLowerCase()) ?? false) ||
            (product.resolution?.toLowerCase().contains(searchText.toLowerCase()) ?? false) ||
            (product.ram?.toLowerCase().contains(searchText.toLowerCase()) ?? false) ||
            (product.storage?.toLowerCase().contains(searchText.toLowerCase()) ?? false) ||
            (product.weight?.toLowerCase().contains(searchText.toLowerCase()) ?? false);
      }).toList();
    }

    if(showAll) filteredProds = productsList;

    update();
  }
  void getSelectedProdProps(){
    nameTec.text = selectedProd.name ?? '';
    manufacturerText = selectedProd.manufacturer ?? phoneManufacturers[0];
    brandController.text = selectedProd.brand ?? '';
    imeiController.text = selectedProd.imei ?? '';
    colorController.text = selectedProd.color ?? '';
    batteryCapacityController.text = selectedProd.batteryCapacity?.toString() ?? '';
    resolutionController.text = selectedProd.resolution ?? '';
    ramController.text = selectedProd.ram?.toString() ?? '';
    storageController.text = selectedProd.storage?.toString() ?? '';
    weightController.text = selectedProd.weight?.toString() ?? '';
    sellPriceTec.text = selectedProd.currPrice?.toInt().toString() ?? '';
    buyPriceTec.text = selectedProd.currBuyPrice?.toInt().toString() ?? '';
    for (var workspace in selectedProd.currQty.keys) {
      qtyControllers[workspace]!.text = selectedProd.currQty[workspace]!.toString();
    }
    //get qtys
    update();
  }

  @override
  void onInit() {
    super.onInit();
    print('## init prdCtr');
    Future.delayed(const Duration(milliseconds: 200), () {

      //refreshProducts();//when app starts + when invoice checked
      prodsSwipeCtr = SwipeActionController(selectedIndexPathsChangeCallback: (changedIndexPaths, selected, currentCount) {
        //print('cell at ${changedIndexPaths.toString()} is/are ${selected ? 'selected' : 'unselected'} ,current selected count is $currentCount');
        update();
      });
      prodsHistorySwipeCtr = SwipeActionController(selectedIndexPathsChangeCallback: (changedIndexPaths, selected, currentCount) {
        update(['historyList']);
      });
      qtyControllers = {
        for (var workspace in workSpaces) workspace: TextEditingController(text: '0')
      };
    });
  }

  //######################################################################################################"############################################

  //dont save 'allItems' in prod cz when you load it it will add new key
  refreshProducts({bool online = true }) async{
     //productsList = await getAlldocsModelsFromFb<Product>((invCtr.downloadProducts || online),productsColl, (invCtr.downloadProducts || online)? (json) => Product.fromJson(json):(json) => Product.fromJsonLocal(json),localKey:productListKey );
     productsList = await getAlldocsModelsFromFb<Product>(true,productsColl,(json) => Product.fromJson(json),localKey:productListKey );
    productsNames = extractNames(productsList);
     runProdFilter(showAll: true);
    update();
  }
  List<String> extractNames(List<Product> prds) {
    List<String> names = [];
    for (var prd in prds) {
      if (prd.name != null) {
        names.add(prd.name!);
      }
    }
    return names;
  }


  // add enw product  // ------------------ PrdOnlineEditProd -----------------------------------------------------------
  addProduct() async {

    final name = nameTec.text;
    final manufacturer = manufacturerText;
    final brand = brandController.text;
    final imei = imeiController.text;
    final color = colorController.text;
    final batteryCapacity = batteryCapacityController.text;
    final resolution = resolutionController.text;
    final ram = ramController.text;
    final storage = storageController.text;
    final weight = weightController.text;
    final sellPrice = sellPriceTec.text;
    final buyPrice = buyPriceTec.text;



    if (!addProductKey.currentState!.validate()) {
      showSnack('Fill in the fields'.tr);

    }
    if (nameTec.text.isEmpty) {
      showSnack('Please enter a device model'.tr);

    }
    if (productsNames.contains(nameTec.text)) {
      showSnack('Product name already exists'.tr);
    }



        try {
          showLoading(text: 'Loading'.tr);

          String specificID = '${name} -ID';
          Product modelToAdd =  Product(

            id: specificID,
            name: name,
            addedTime: todayToString(),
            color: color,
            batteryCapacity: batteryCapacity,
            brand:brand ,
            imei:imei ,
            manufacturer:manufacturer ,
            ram: ram,
            resolution:resolution ,
            storage:storage ,
            weight: weight,
            currPrice: double.parse(sellPrice),
            currBuyPrice: double.parse(buyPrice),

            currQty: getCurrQtyFromControllers(),

            buyHis: {},
            sellHis: {},




          );
          Map<String, dynamic> modelMapToAdd = modelToAdd.toJson();

          //online
          if(prdOnlineAdd){
            var value = await addDocument(
              fieldsMap: modelMapToAdd,
              coll  : productsColl,
              specificID: specificID,
            );
          }

          ///----- success--------
          Get.back(); //hide loading
          Get.back(); //
          refreshProducts();


        } catch (error) {
          print("## Failed to add new product: $error");
          showTos("Failed to add new product".tr);
        }

  }


  // maybe add condition that you cant delete prod included in non-checked (waiting) inv
  removeProduct(Product product)async{
    try{

      //online
      if(prdOnlineRemove){
        var value = await  deleteDoc(
            docID: product.id!,
            coll: productsColl
        );
      }

      ///----- success
      invCtr.refreshInvoices(withPrdsRefresh: true);
      print('## product <${product.name}> removed');
      showSnack('"${product.name}" ${'removed'.tr}', color: Colors.redAccent.withOpacity(0.8));

      update();

    }catch(error){
      print('## Failed to remove product <${product.name}>: $error ');


    }
  }

  // ------------------ PrdOnlineEditProd -----------------------------------------------------------
  /// add/subtract qty from current-qty
  updateProduct(String productID,{double? currPrice ,double? currBuyPrice,int? currQty}) async {
    //showLoading(text: 'Loading...'.tr);

    Map<String,dynamic> updatedMap = {};
    Product updatedProd =  getProductById(productID);//offline


      if(currPrice != null){
        updatedMap['currPrice']= currPrice;
      }
      if(currQty != null){/// update this after (+/-) the qty
        updatedMap['currQty'][cWs]= currQty;

      }
      if(currBuyPrice != null){
        updatedMap['currBuyPrice']= currBuyPrice;
      }


        try {


          if(prdOnlineEdit) {
            await productsColl.doc(productID).update(updatedMap); //online
          }


          ///--- success
          sellPriceTec.clear();
          update();
        }catch(error){
          print('## prod failed to update :$error');

        }



  }

  //THIS ARE USED IN FOR LOOP

  /// this is added manuallu in (+) btn of each product card
  Future<void>  addBuyProc({required Product prod,required int chosenQty,required String invID,required String clientName,required double inputPrice}) async {

    Map mapToAdd = BuySellProd(

      price: inputPrice,
      qty: chosenQty,
      restQty: prod.currQty[cWs]! + chosenQty ,/// restQty
      total:  inputPrice * chosenQty,

      time: todayToString(),
      society: clientName,//user enter this
      driver: '',//user enter this
      mf:'',//user enter this
      to: cWs,
      invID:invID,//

    ).toJson();

    //offline
    Product updatedProd =  getProductById(prod.id!);
    if(updatedProd == '') {
      showSnack('product not found to sell'.tr,color:Colors.black54);
      print('## product not found to sell');
      throw Exception('## Exception ');
    }
    Map<String, dynamic> fieldMap = updatedProd.buyHis;
    String mapKeyToAdd = '0b'+getLastIndex(fieldMap,cr:'0b', afterLast: true);//new key

    fieldMap[mapKeyToAdd] = mapToAdd;

    updatedProd.buyHis = fieldMap;// update 'buyHis'


    //online
    if(prdOnlineEdit){
          await  addToMap(
            coll: productsColl,
            docID: prod.id,
            fieldMapName: 'buyHis',
            mapToAdd: mapToAdd,
            );
    }

    //----- success
    updateProduct(prod.id!, currQty: prod.currQty[cWs]! + chosenQty, currBuyPrice: inputPrice);
    print('## <${prod.name}> made < BUY > process (increase qty) "${prod.currQty[cWs]!} + <${chosenQty}> = ${prod.currQty[cWs]! + chosenQty} " + Change currBuyPrice [${prod.currBuyPrice}]=>[${inputPrice}]');


  }
  /// these are added automatically in the invoice in for loop one call for each product
  Future<void>  addSellProc({required Product prod,required int chosenQty,required String invID,required String clientName,required double income,required double inputPrice}) async {//merge with kridi

    Map mapToAdd =  BuySellProd(
      price: inputPrice,
      qty: chosenQty,
      restQty: prod.currQty[cWs]! - chosenQty < 0 ? 0 : prod.currQty[cWs]! - chosenQty,
      /// restQty
      total: inputPrice * chosenQty,
      income: income,
      time: todayToString(),
      society: cWs,
      invID: invID,
      to: clientName,
    ).toJson();

    //offline
    Product updatedProd =  getProductById(prod.id!);//get product by ID
    if(updatedProd == null) {
      showSnack('product not found to sell'.tr,color:Colors.black54);
      print('## product not found to sell');
      throw Exception('## Exception ');
    }

    Map<String, dynamic> fieldMap = updatedProd.sellHis;
    String mapKeyToAdd = '0s'+ getLastIndex(fieldMap,cr:'0s', afterLast: true);//new key

    fieldMap[mapKeyToAdd] = mapToAdd;



    updatedProd.sellHis = fieldMap;// update 'sellHis'

    //online
    if(prdOnlineEdit) {
    await  addToMap(
          coll: productsColl,
          docID: prod.id,
          //withBackDialog: true,
          fieldMapName: 'sellHis',
          mapToAdd:mapToAdd,
    );
    }
    //----- success
    print('## <${prod.name}> made < SELL > process (decrease qty) "${prod.currQty[cWs]!} - <${chosenQty}> = ${prod.currQty[cWs]! - chosenQty} "');

    updateProduct(prod.id!, currQty: prod.currQty[cWs]! - chosenQty < 0 ? 0 : prod.currQty[cWs]! - chosenQty);
  }
  /// these are added automatically in the invoice in for loop one call for each product
  Future<void>  addReturnProc({required Product prod,required int chosenQty,required String invID,required bool isBuyInv}) async {

    //offline
    Product updatedProd =  getProductById(prod.id!);
    if(updatedProd == '') {
      showSnack('product not found to sell'.tr,color:Colors.black54);
      print('## product not found to sell');
      throw Exception('## Exception ');
    }



    Map<String, dynamic> fieldMap = deleteFromMapLocal(
      mapInitial: isBuyInv? updatedProd.buyHis:updatedProd.sellHis,
      targetInvID: invID,
    );
    if(fieldMap.isNotEmpty){
      if (isBuyInv) {
        updatedProd.buyHis = fieldMap;
      } else {
        updatedProd.sellHis = fieldMap;
      }
    }



    //online
    if(prdOnlineEdit){
           deleteFromMap(
            coll: productsColl,
            docID: prod.id,
            fieldMapName: isBuyInv ? 'buyHis' : 'sellHis',
            targetInvID: invID
          );
        }


        ///------ success
    if (isBuyInv) {
      updateProduct(prod.id!, currQty: prod.currQty[cWs]! - chosenQty);
      ///auto return of buy invoice
      print('## <${prod.name}> made < RETURN >from<buy> process (decrease qty) "${prod.currQty[cWs]!} - <${chosenQty}> = ${prod.currQty[cWs]! - chosenQty} "');
    }
    else {
      updateProduct(prod.id!, currQty: prod.currQty[cWs]! + chosenQty);
      ///auto return of sell invoice
      print('## <${prod.name}> made < RETURN >from<sell> process (increase qty) "${prod.currQty[cWs]!} + <${chosenQty}> = ${prod.currQty[cWs]! + chosenQty} "');
    }
  }
  /// this process made at first time adding the product & when you edit prd with pencil btn
  updateProductWithManualChange() async {//MAnual Changes



    print('## price: ${selectedProd.currPrice} / qty: ${selectedProd.currQty[cWs]}');
    if (addProductKey.currentState!.validate() ) {
      //get new vars

     String _manufacturer = manufacturerText;
     String _brand = brandController.text;
     String  _imei = imeiController.text;
     String  _color = colorController.text;
     String  _batteryCapacity = batteryCapacityController.text;
     String _resolution = resolutionController.text;
     String _ram = ramController.text;
     String _storage = storageController.text;
     String  _weight = weightController.text;
      double _sellPrice =  double.parse(sellPriceTec.text) ;
      double _buyPrice =  double.parse(buyPriceTec.text);
     String _qtyChanges =   quantitiesChanges(selectedProd.currQty);



     // Check for changes and collect changed fields
     Map<String, dynamic> changedFields = {};


     bool prodChanged = false;
     String prodUpdatesDesc = '';


     // Check for changes and collect changed fields
     if (_manufacturer != selectedProd.manufacturer) {
       changedFields['manufacturer'] = _manufacturer;
       prodChanged = true;
       prodUpdatesDesc += '-Manufacturer changed from "${selectedProd.manufacturer}" to "$_manufacturer", \n';
     }
     if (_brand != selectedProd.brand) {
       changedFields['brand'] = _brand;
       prodChanged = true;
       prodUpdatesDesc += '-Brand changed from "${selectedProd.brand}" to "$_brand", \n';
     }
     if (_imei != selectedProd.imei) {
       changedFields['imei'] = _imei;
       prodChanged = true;
       prodUpdatesDesc += '-IMEI changed from "${selectedProd.imei}" to "$_imei", \n';
     }
     if (_color != selectedProd.color) {
       changedFields['color'] = _color;
       prodChanged = true;
       prodUpdatesDesc += '-Color changed from "${selectedProd.color}" to "$_color", \n';
     }
     if (_batteryCapacity != selectedProd.batteryCapacity) {
       changedFields['batteryCapacity'] = _batteryCapacity;
       prodChanged = true;
       prodUpdatesDesc += '-Battery Capacity changed from "${selectedProd.batteryCapacity}" to "$_batteryCapacity", \n';
     }
     if (_resolution != selectedProd.resolution) {
       changedFields['resolution'] = _resolution;
       prodChanged = true;
       prodUpdatesDesc += '-Resolution changed from "${selectedProd.resolution}" to "$_resolution", \n';
     }
     if (_ram != selectedProd.ram) {
       changedFields['ram'] = _ram;
       prodChanged = true;
       prodUpdatesDesc += '-RAM changed from "${selectedProd.ram}" to "$_ram", \n';
     }
     if (_storage != selectedProd.storage) {
       changedFields['storage'] = _storage;
       prodChanged = true;
       prodUpdatesDesc += '-Storage changed from "${selectedProd.storage}" to "$_storage", \n';
     }
     if (_weight != selectedProd.weight) {
       changedFields['weight'] = _weight;
       prodChanged = true;
       prodUpdatesDesc += '-Weight changed from "${selectedProd.weight}" to "$_weight", \n';
     }
     if (_sellPrice != selectedProd.currPrice) {
       changedFields['currPrice'] = _sellPrice;
       prodChanged = true;
       prodUpdatesDesc += '-Sell Price changed from "${selectedProd.currPrice}" to "$_sellPrice", \n';
     }
     if (_buyPrice != selectedProd.currBuyPrice) {
       changedFields['currBuyPrice'] = _buyPrice;
       prodChanged = true;
       prodUpdatesDesc += '-Buy Price changed from "${selectedProd.currBuyPrice}" to "$_buyPrice", \n';
     }


     if (_qtyChanges != '') {
       changedFields['currQty'] = getCurrQtyFromControllers();
       prodChanged = true;
       prodUpdatesDesc += '-Quantities changed:  $_qtyChanges \n';
     }




      if( prodChanged ){
        showLoading(text: 'Loading'.tr);


        try {


          String specificID = Uuid().v1();

          Note newUpdateNote =Note(
            id: specificID,
            clientName: '',
            date: todayToString(showHoursNminutes: true ),
            description: prodUpdatesDesc,
            type: '"${selectedProd.name}" updated',
            workerID: cUser.id,
            workerName: cUser.name,
            workSpace: cWs,

          );

          //online
          if(prdOnlineEdit){
            await productsColl.doc(selectedProd.id).update(changedFields);
             await addDocument(
              fieldsMap: newUpdateNote.toJson(),
              coll  : notesColl,
              specificID: specificID,
            );
          }

          ///----- success
          invCtr.refreshInvoices(withPrdsRefresh: true);
          noteCtr.refreshNotes();
          Get.back();
          Get.back();
          showSnack('"${selectedProd.name}" updated'.tr, color: Colors.black54);

          Future.delayed(const Duration(milliseconds: 500), () {
            update();
          });

        } catch (error) {
          print('## product failed to be edited manually : $error');
          showSnack('product failed to be edited manually'.tr, color: Colors.redAccent.withOpacity(0.8));
        }
      }else{
        print('## you need to make changes');
        showSnack('you need to make changes'.tr,color:Colors.black54);
      }
    }
  }

  String quantitiesChanges(Map<String, int> currQty) {
    String qtyChangesDetails = '';
    for (var entry in qtyControllers.entries) {
      String workSpace = entry.key;
      TextEditingController controller = entry.value;
      int? originalQty = currQty[workSpace];
      int newQty =int.parse(controller.text);

      if (newQty != originalQty) {

        qtyChangesDetails += ' in $workSpace: ($originalQty -> $newQty),';
      }
    }
    return qtyChangesDetails;
  }


}