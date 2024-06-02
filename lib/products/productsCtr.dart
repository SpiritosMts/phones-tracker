

  import 'dart:convert';
  import 'dart:math';

  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
  import 'package:phones_tracker/_manager/bindings.dart';
  import 'package:get/get.dart';
import 'package:phones_tracker/privateData.dart';

  import '../_manager/firebaseVoids.dart';
  import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
  import '../_manager/styles.dart';
  import '../_models/affectedDev.dart';
  import '../_models/product.dart';
  import 'package:uuid/uuid.dart';



  List<String> phoneManufacturers = [];

  List<String> StaticPhoneManufacturers = [
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
  List<String> statesAff = [
    'Waiting',
    'In Review',
    'Ready',

  ];
  List<String> ramValues = [
    // '1GB',
    // '2GB',
    // '3GB',
    // '4GB',
    // '6GB',
    // '8GB',
    // '12GB',
    // '16GB',
    // '32GB',
  ];

  List<String> storageValues = [
    // '8GB',
    // '16GB',
    // '32GB',
    // '64GB',
    // '128GB',
    // '256GB',
    // '512GB',
    // '1TB'
  ];
  List<String> modelValues = [
    // 'Pixel 4a',
    // 'Pixel 5',
    // 'Pixel 6',
    // 'Pixel 7',
    // 'Mi 11',
    // 'Redmi Note 10',
    // 'Mi 10T',
    // 'Poco X3',
    // 'iPhone 12',
    // 'iPhone 11',
    // 'iPhone SE', 'iPhone XR','Galaxy S21', 'Galaxy A52', 'Galaxy Note 20', 'Galaxy Z Fold 3',
    //     'P40', 'Mate 40', 'P30', 'Nova 7','OnePlus 8', 'OnePlus 9', 'OnePlus Nord', 'OnePlus 7T',
    // 'Xperia 5', 'Xperia 1', 'Xperia 10', 'Xperia L4','G8 ThinQ', 'V60 ThinQ', 'Velvet',
    // 'Wing','Nokia 8.3', 'Nokia 5.3', 'Nokia 7.2', 'Nokia 6.2'
  ];//++
  List<String> colorValues = [
    // 'Red',
    // 'Blue',
    // 'Green',
    // 'Black',
    // 'White',
    // 'Gray',
    // 'Yellow',
    // 'Purple',
    // 'Pink',
    // 'Orange'
  ];
  List<String> workSpaces = [

  ];//++
  class ProductsCtr extends GetxController {


    bool showList = true;

    bool isNewModelAdded = false;


    List<String> modelsDrop = modelValues;


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
    String manufacturerText = phoneManufacturers[0];
    String ModelTec = modelValues[0];
    String ramController =ramValues[0];
    String storageController = storageValues[0];
    String colorController = colorValues[0];

    final brandController = TextEditingController();
    final imeiController = TextEditingController();
    final batteryCapacityController = TextEditingController();
    final resolutionController = TextEditingController();
    final weightController = TextEditingController();


    final sellPriceTec = TextEditingController(text: '0');
    final buyPriceTec = TextEditingController(text: '0');
    //final qtyTec = TextEditingController();
    Map<String, TextEditingController> qtyControllers = {};



    //######################################################################################################"


    late SwipeActionController prodsSwipeCtr;
    late SwipeActionController prodsHistorySwipeCtr;

    void clearControllers() {
      ModelTec=modelValues[0];
      manufacturerText = phoneManufacturers[0];
      storageController=storageValues[0];
      colorController= colorValues[0];
      ramController=ramValues[0];

      brandController.clear();
      imeiController.clear();
      batteryCapacityController.clear();
      resolutionController.clear();
      weightController.clear();
      sellPriceTec.clear();
      buyPriceTec.clear();
      //qtyTec.clear();
      qtyControllers = {
        for (var workspace in workSpaces) workspace: TextEditingController(text: '0')
      };
      update();

    }

   String searchModelTec=modelValues[0];
   String searchBrandTec=phoneManufacturers[0];
    String searchstorageController=storageValues[0];
    String searchcolorController= colorValues[0];
    String searchramController=ramValues[0];

    runProdFilter({String manu ='',bool byFilter =false,bool showAll =false,}){
      //show all
      // how to get from List<Product> only products with manufactur == 'apple'
      if(manu.isNotEmpty) {
        filteredProds = productsList.where((product) => product.manufacturer?.toLowerCase() == manu.toLowerCase()).toList();
      }

      if(byFilter){
        filteredProds = productsList.where((product) {
          return
              (product.name!.toLowerCase() == searchModelTec.toLowerCase()) &&
              (product.color!.toLowerCase()== searchcolorController.toLowerCase()) &&
              (product.ram!.toLowerCase()== searchramController.toLowerCase()) &&
              //(product.manufacturer!.toLowerCase()== searchBrandTec.toLowerCase()) &&
              (product.storage!.toLowerCase()== searchstorageController.toLowerCase());
        }).toList();
      }

      print('## (${filteredProds.length}) items have model<$searchModelTec> color<$searchcolorController> ram<$searchramController> storage<$searchstorageController> ');

      if(showAll) filteredProds = productsList;

      update();
    }
    void getSelectedProdProps(){
      ModelTec = selectedProd.name ?? '';
      manufacturerText = selectedProd.manufacturer ?? phoneManufacturers[0];
      brandController.text = selectedProd.brand ?? '';
      imeiController.text = selectedProd.imei ?? '';
      colorController = selectedProd.color ?? '';
      batteryCapacityController.text = selectedProd.batteryCapacity?.toString() ?? '';
      resolutionController.text = selectedProd.resolution ?? '';
      ramController = selectedProd.ram?.toString() ?? '';
      storageController = selectedProd.storage?.toString() ?? '';
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

      final name = ModelTec;
      final manufacturer = manufacturerText;
      final brand = brandController.text;
      final imei = imeiController.text;
      final color = colorController;
      final batteryCapacity = batteryCapacityController.text;
      final resolution = resolutionController.text;
      final ram = ramController;
      final storage = storageController;
      final weight = weightController.text;
      final sellPrice = sellPriceTec.text;
      final buyPrice = buyPriceTec.text;


      //
      if (!addProductKey.currentState!.validate()) {
        showSnack('Fill in the fields'.tr);
        return;
      }
      // if (ModelTec.isEmpty) {
      //   showSnack('Please enter a device model'.tr);
      //
      // }
      // if (productsNames.contains(ModelTec)) {
      //   showSnack('Product name already exists'.tr);
      // }



          try {
            showLoading(text: 'Loading'.tr);

            //String specificID = '${name} -ID';
            String specificID = Uuid().v1();

            Product modelToAdd =  Product(

              id: specificID,
              name: name,
              addedTime: todayToString(showHoursNminutes: true),
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
          Map<String,int> crQty = updatedProd.currQty;
          crQty[cWs]= currQty;
          updatedMap['currQty'] =crQty;
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
    /// these are added automatically in the invoice in for loop one call for each product
    Future<void>  addSellProc({required Product prod,required int chosenQty,required String invID,required String clientName,required double income,required double inputPrice}) async {//merge with kridi


      //offline
      Product updatedProd =  getProductById(prod.id!);//get product by ID
      if(updatedProd == null) {
        showSnack('product not found to sell'.tr,color:Colors.black54);
        print('## product not found to sell');
        throw Exception('## Exception ');
      }

      Map<String, dynamic> fieldMap = updatedProd.sellHis;
      String mapKeyToAdd = '0s'+ getLastIndex(fieldMap,cr:'0s', afterLast: true);//new key






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

       String _model = ModelTec;
       String _manufacturer = manufacturerText;
       String _brand = brandController.text;
       String  _imei = imeiController.text;
       String  _batteryCapacity = batteryCapacityController.text;
       String _resolution = resolutionController.text;
       String _ram = ramController;
       String  _color = colorController;
       String _storage = storageController;
       String  _weight = weightController.text;
        double _sellPrice =  double.parse(sellPriceTec.text) ;
        double _buyPrice =  double.parse(buyPriceTec.text);
       String _qtyChanges =   quantitiesChanges(selectedProd.currQty);



       // Check for changes and collect changed fields
       Map<String, dynamic> changedFields = {};


       bool prodChanged = false;


       // Check for changes and collect changed fields
       if (_manufacturer != selectedProd.manufacturer) {
         changedFields['manufacturer'] = _manufacturer;
         prodChanged = true;
       }
       if (_model != selectedProd.name) {
         changedFields['name'] = _model;
         prodChanged = true;
       }


       if (_color != selectedProd.color) {
         changedFields['color'] = _color;
         prodChanged = true;
       }

       if (_ram != selectedProd.ram) {
         changedFields['ram'] = _ram;
         prodChanged = true;
       }
       if (_storage != selectedProd.storage) {
         changedFields['storage'] = _storage;
         prodChanged = true;
       }

       if (_sellPrice != selectedProd.currPrice) {
         changedFields['currPrice'] = _sellPrice;
         prodChanged = true;
       }
       if (_buyPrice != selectedProd.currBuyPrice) {
         changedFields['currBuyPrice'] = _buyPrice;
         prodChanged = true;
       }


       if (_qtyChanges != '') {
         changedFields['currQty'] = getCurrQtyFromControllers();
         prodChanged = true;
       }




        if( prodChanged ){
          showLoading(text: 'Loading'.tr);


          try {



            //online
            if(prdOnlineEdit){
              await productsColl.doc(selectedProd.id).update(changedFields);

            }

            ///----- success
            invCtr.refreshInvoices(withPrdsRefresh: true);
            Get.back();
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
        }
        else{
          print('## you need to make changes');
          showSnack('you need to make changes'.tr,color:Colors.black54);
        }
      }
    }
    @override
    void onClose() {
      // Dispose all controllers when the controller is closed to avoid memory leaks
      for (var controller in imeiControllers) {
        controller.dispose();
      }
      super.onClose();
    }
    List<TextEditingController> imeiControllers = [];

    // Function to initialize the list of IMEI controllers
    void initializeIMEIControllers(int count) {
      imeiControllers.clear(); // Clear the list to ensure it's empty
      for (int i = 0; i < count; i++) {
        imeiControllers.add(TextEditingController()); // Add new controllers to the list
      }
    }

    ///model
    ShowAddNewModel() {

      final modNameTec = TextEditingController();


      addModel() async {
        if(modNameTec.text.isNotEmpty && !modelValues.contains(modNameTec.text)){
          try {
            // Reference to the Firestore document
            DocumentReference documentReference = FirebaseFirestore.instance.collection('prData').doc('prData');

            // Update the document with the new field and array value
            await documentReference.update({
              'models': FieldValue.arrayUnion([modNameTec.text]),
            });

            Get.back();
            modelValues.add(modNameTec.text);
            getPrivateData();//refresh models
            update();

            showSnack('Model "${modNameTec.text}" Added');
          } catch (error) {
            print('Error adding field to array in Firestore: $error');
          }
        }else{
          showSnack('Model cant be added');

        }
      }

      return AlertDialog(
        backgroundColor: dialogBgCol,
        title: Text(
          'Add New Model'.tr,
          style: TextStyle(
            color: dialogTitleCol,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: GetBuilder<ProductsCtr>(
            initState: (_) {

            },
            dispose: (_) {
            },
            builder: (_) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  /// components

                  SizedBox(height: 10,),



                  customTextField(
                    controller: modNameTec,
                    labelText: 'Model Name'.tr,
                    icon: Icons.phone_android,
                  ),



                  SizedBox(
                    height: 18,
                  ),


                  /// buttons
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //cancel
                        TextButton(
                          style: borderBtnStyle(),
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel".tr,
                            style: TextStyle(color: dialogBtnCancelTextCol),
                          ),
                        ),
                        //add
                        TextButton(
                          style: filledBtnStyle(),
                          onPressed: ()  {
                            addModel();
                          },
                          child: Text(
                            "Add".tr,
                            style: TextStyle(color: dialogBtnOkTextCol),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    }


    ///brand
    ShowAddNewBrand() {

      final modNameTec = TextEditingController();


      addModel() async {
        if(modNameTec.text.isNotEmpty && !modelValues.contains(modNameTec.text)){
          try {
            // Reference to the Firestore document
            DocumentReference documentReference = FirebaseFirestore.instance.collection('prData').doc('prData');

            // Update the document with the new field and array value
            await documentReference.update({
              'brand': FieldValue.arrayUnion([modNameTec.text]),
            });

            Get.back();
            phoneManufacturers.add(modNameTec.text);
            getPrivateData();//refresh models
            update();

          } catch (error) {
            print('Error adding field to array in Firestore: $error');
          }
        }else{

        }
      }

      return AlertDialog(
        backgroundColor: dialogBgCol,
        title: Text(
          'Add New Brand'.tr,
          style: TextStyle(
            color: dialogTitleCol,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: GetBuilder<ProductsCtr>(
            initState: (_) {

            },
            dispose: (_) {
            },
            builder: (_) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  /// components

                  SizedBox(height: 10,),



                  customTextField(
                    controller: modNameTec,
                    labelText: 'New Value'.tr,
                    icon: Icons.phone_android,
                  ),



                  SizedBox(
                    height: 18,
                  ),


                  /// buttons
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //cancel
                        TextButton(
                          style: borderBtnStyle(),
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel".tr,
                            style: TextStyle(color: dialogBtnCancelTextCol),
                          ),
                        ),
                        //add
                        TextButton(
                          style: filledBtnStyle(),
                          onPressed: ()  {
                            addModel();
                          },
                          child: Text(
                            "Add".tr,
                            style: TextStyle(color: dialogBtnOkTextCol),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    }


    ///ram
    ShowAddNewRAM() {

      final modNameTec = TextEditingController();


      addModel() async {
        if(modNameTec.text.isNotEmpty && !modelValues.contains(modNameTec.text)){
          try {
            // Reference to the Firestore document
            DocumentReference documentReference = FirebaseFirestore.instance.collection('prData').doc('prData');

            // Update the document with the new field and array value
            await documentReference.update({
              'ram': FieldValue.arrayUnion([modNameTec.text]),
            });

            Get.back();
            ramValues.add(modNameTec.text);
            getPrivateData();//refresh models
            update();

          } catch (error) {
            print('Error adding field to array in Firestore: $error');
          }
        }else{

        }
      }

      return AlertDialog(
        backgroundColor: dialogBgCol,
        title: Text(
          'Add New RAM'.tr,
          style: TextStyle(
            color: dialogTitleCol,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: GetBuilder<ProductsCtr>(
            initState: (_) {

            },
            dispose: (_) {
            },
            builder: (_) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  /// components

                  SizedBox(height: 10,),



                  customTextField(
                    controller: modNameTec,
                    labelText: 'New Value'.tr,
                    icon: Icons.phone_android,
                  ),



                  SizedBox(
                    height: 18,
                  ),


                  /// buttons
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //cancel
                        TextButton(
                          style: borderBtnStyle(),
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel".tr,
                            style: TextStyle(color: dialogBtnCancelTextCol),
                          ),
                        ),
                        //add
                        TextButton(
                          style: filledBtnStyle(),
                          onPressed: ()  {
                            addModel();
                          },
                          child: Text(
                            "Add".tr,
                            style: TextStyle(color: dialogBtnOkTextCol),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    }


    ///Storage
    ShowAddNewStorage() {

      final modNameTec = TextEditingController();


      addModel() async {
        if(modNameTec.text.isNotEmpty && !modelValues.contains(modNameTec.text)){
          try {
            // Reference to the Firestore document
            DocumentReference documentReference = FirebaseFirestore.instance.collection('prData').doc('prData');

            // Update the document with the new field and array value
            await documentReference.update({
              'storage': FieldValue.arrayUnion([modNameTec.text]),
            });

            Get.back();
            storageValues.add(modNameTec.text);

            getPrivateData();//refresh models
            update();

          } catch (error) {
            print('Error adding field to array in Firestore: $error');
          }
        }else{

        }
      }

      return AlertDialog(
        backgroundColor: dialogBgCol,
        title: Text(
          'Add New Storage'.tr,
          style: TextStyle(
            color: dialogTitleCol,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: GetBuilder<ProductsCtr>(
            initState: (_) {

            },
            dispose: (_) {
            },
            builder: (_) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  /// components

                  SizedBox(height: 10,),



                  customTextField(
                    controller: modNameTec,
                    labelText: 'New Value'.tr,
                    icon: Icons.phone_android,
                  ),



                  SizedBox(
                    height: 18,
                  ),


                  /// buttons
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //cancel
                        TextButton(
                          style: borderBtnStyle(),
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel".tr,
                            style: TextStyle(color: dialogBtnCancelTextCol),
                          ),
                        ),
                        //add
                        TextButton(
                          style: filledBtnStyle(),
                          onPressed: ()  {
                            addModel();
                          },
                          child: Text(
                            "Add".tr,
                            style: TextStyle(color: dialogBtnOkTextCol),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    }


    ///color
    ShowAddNewColor() {

      final modNameTec = TextEditingController();


      addModel() async {
        if(modNameTec.text.isNotEmpty && !modelValues.contains(modNameTec.text)){
          try {
            // Reference to the Firestore document
            DocumentReference documentReference = FirebaseFirestore.instance.collection('prData').doc('prData');

            // Update the document with the new field and array value
            await documentReference.update({
              'color': FieldValue.arrayUnion([modNameTec.text]),
            });

            Get.back();
            colorValues.add(modNameTec.text);
            getPrivateData();//refresh models
            update();
          } catch (error) {
            print('Error adding field to array in Firestore: $error');
          }
        }else{

        }
      }

      return AlertDialog(
        backgroundColor: dialogBgCol,
        title: Text(
          'Add New Color'.tr,
          style: TextStyle(
            color: dialogTitleCol,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: GetBuilder<ProductsCtr>(
            initState: (_) {

            },
            dispose: (_) {
            },
            builder: (_) => SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  /// components

                  SizedBox(height: 10,),



                  customTextField(
                    controller: modNameTec,
                    labelText: 'Color Name'.tr,
                    icon: Icons.phone_android,
                  ),



                  SizedBox(
                    height: 18,
                  ),


                  /// buttons
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //cancel
                        TextButton(
                          style: borderBtnStyle(),
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel".tr,
                            style: TextStyle(color: dialogBtnCancelTextCol),
                          ),
                        ),
                        //add
                        TextButton(
                          style: filledBtnStyle(),
                          onPressed: ()  {
                            addModel();
                          },
                          child: Text(
                            "Add".tr,
                            style: TextStyle(color: dialogBtnOkTextCol),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
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







    /// ********************************* affected devices **************************
    List<AffectedDev> affetedDevs = [];
    AffectedDev selectedAff = AffectedDev();
    seletAff(aff){
      selectedAff=aff;
      update();
    }
    GlobalKey<FormState> addAffKey = GlobalKey<FormState>();
    final affClientTec = TextEditingController();
    String stateAff = statesAff[0];
    String modelAff = modelValues[0];
    final imeiAffController = TextEditingController();
    final descAffController = TextEditingController();

    refreshAffecteds() async {
      affetedDevs = await getAlldocsModelsFromFb<AffectedDev>( // refresh other users
          true, affectedColl, (json) => AffectedDev.fromJson(json),
          localKey: '');
      update();

      affetedDevs.sort((a, b) {
        //order by date
        DateTime timeA = dateFormatHM.parse(a.time!);
        DateTime timeB = dateFormatHM.parse(b.time!);
        return timeB.compareTo(timeA);
      });

    }

    removeAffected(aff) async {
      try{

        bool accept = await showNoHeader(txt: 'are you sure you want to remove this affected device ?',btnOkText: 'Remove');
        if(!accept) return;

        var value = await  deleteDoc(
            docID: aff.id!,
            coll: affectedColl
        );


        ///----- success

        update();

        refreshAffecteds();
      }catch(error){
        print('## Failed to remove aff : $error ');


      }
    }
    void clearAffControllers() {
      affClientTec.clear();
      imeiAffController.clear();
      descAffController.clear();
      stateAff = statesAff[0];
      modelAff = modelValues[0];

      update();

    }
    void getAffSelectedProdProps(){
      affClientTec.text = selectedAff.name ?? '';
      imeiAffController.text = selectedAff.imei ?? '';
      descAffController.text = selectedAff.desc ?? '';
      modelAff = selectedAff.model ?? modelValues[0];
      stateAff = selectedAff.state ?? statesAff[0];

      //get qtys
      update();
    }

    updateAff() async {
      if (addAffKey.currentState!.validate() ) {
        Map<String, dynamic> changedFields = {};


        bool prodChanged = false;

        String _imei = imeiAffController.text;
        String _desc = descAffController.text;
        String _state = stateAff;
        String _model = modelAff;

        if (_imei != selectedAff.imei) {
          changedFields['imei'] = _imei;
          prodChanged = true;
        }
        if (_desc != selectedAff.desc) {
          changedFields['desc'] = _desc;
          prodChanged = true;
        }
        if (_state != selectedAff.state) {
          changedFields['state'] = _state;
          prodChanged = true;
        }
        if (_model != selectedAff.model) {
          changedFields['model'] = _model;
          prodChanged = true;
        }


if(prodChanged)  {
        try {
          await affectedColl.doc(selectedAff.id).update(changedFields);

          ///----- success
          refreshAffecteds();
          Get.back();

          Future.delayed(const Duration(milliseconds: 500), () {
            update();
          });
        } catch (error) {}
      }else{
  showSnack('Please make changes'.tr);
}
    }else{

      }
    }

    addAff() async {

      if (!addAffKey.currentState!.validate() ) {
        showSnack('Please fill in the fields...'.tr);
        return;
      }

      try {
        showLoading(text: 'Loading'.tr);
        String specificID = Uuid().v1();
        AffectedDev aff =  AffectedDev(
          id: specificID,
          desc: descAffController.text,
          imei: imeiAffController.text,
          name: affClientTec.text,
          model: modelAff,
          state: stateAff,
          wrkSpace: cWs,
          time: todayToString(showHoursNminutes: true ),




        );

        var value = await addDocument(
          fieldsMap: aff.toJson(),
          coll  : affectedColl,
          specificID: specificID,
        );


        ///----- success--------
        Get.back(); //hide loading
        Get.back(); //hide dialog

        refreshAffecteds();


      } catch (error) {

      }

    }



  }