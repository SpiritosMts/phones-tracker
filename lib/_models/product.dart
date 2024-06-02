


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../_manager/bindings.dart';
import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
import '../products/productsCtr.dart';
import 'invoice.dart';

class Product {
  String? id;
  String? addedTime;

  ///props
  String? name;//by user
  String? manufacturer;
  String? brand;
  String? imei;
  String? color;
  String? batteryCapacity;
  String? resolution;
  String? ram;
  String? storage;
  String? weight;

  ///prices
  double? currPrice;//
  double? currBuyPrice;//
  /// qty
  Map<String, int> currQty; // Modified to a map
  Map<String, int> currQtyReduced;//no db
  /// history
  Map<String, dynamic> prodChanges;
  Map<String, dynamic> buyHis;
  Map<String, dynamic> sellHis;
  Map<String, dynamic> allItems;//no db

  Product({
    this.id = '',
    this.name= '',
    this.addedTime= '',
    this.manufacturer= '',
    this.brand= '',
    this.imei= '',
    this.color= '',
    this.batteryCapacity= '',
    this.resolution= '',
    this.ram= '',
    this.storage= '',
    this.weight= '',
    this.currPrice= 0.0,
    this.currBuyPrice= 0.0,
    this.currQty= const{},
    this.currQtyReduced= const{},
    this.prodChanges= const{},
    this.allItems= const{},
    this.buyHis= const{},
    this.sellHis= const{},
  }) ;
  //: currQty = {for (var workspace in workSpaces) workspace: 0};



  //affected by invoices out
  factory Product.fromJson(Map<String, dynamic> json) {

    Map<String, dynamic> sellHis = Map<String, dynamic>.from(json['sellHis']);//make copy from map 'json['sellHis']'
    Map<String, dynamic> buyHis = Map<String, dynamic>.from(json['buyHis']);
    Map<String, dynamic> prodChanges = Map<String, dynamic>.from(json['prodChanges']);

    Map<String, int> currQty = Map<String, int>.from(json['currQty']);
    if (json['currQty'] != null) {
      (json['currQty'] as Map<String, dynamic>).forEach((key, value) {
        if (workSpaces.contains(key)) {
          currQty[key] = value;
        }
      });
    }
    return Product(
      id: json['id'],
      name: json['name'],

      addedTime: json['addedTime'],
      manufacturer: json['manufacturer'],
      brand: json['brand'],
      imei: json['imei'],
      color: json['color'],
      batteryCapacity: json['batteryCapacity'],
      resolution: json['resolution'],
      ram: json['ram'],
      storage: json['storage'],
      weight: json['weight'],
      //currPrice: getLastIndexMap(prodChanges)['price'],
      currPrice: json['currPrice'].toDouble(),
      currBuyPrice: json['currBuyPrice'].toDouble(),
      //currQty:  getLastIndexMap(prodChanges)['qty'],
      currQtyReduced:  currQty ,//currQty - qtyToSub
      currQty:  currQty ,

      prodChanges: prodChanges,
      buyHis: buyHis,
      sellHis: sellHis,
     // allItems: allItems,
    );
  }

  Map<String, dynamic> toJson() {

    Map<String, dynamic> sellHis = Map<String, dynamic>.from(this.sellHis);//make copy from map 'json['sellHis']'
    Map<String, dynamic> buyHis = Map<String, dynamic>.from(this.buyHis);
    Map<String, dynamic> prodChanges = Map<String, dynamic>.from(this.prodChanges);

    Map<String, int> currQty = Map<String, int>.from(this.currQty);
    Map<String, int> currQtyReduced = Map<String, int>.from(this.currQtyReduced);

    sellHis = removeSubstringFromKeys('0s', sellHis);
    buyHis = removeSubstringFromKeys('0b', buyHis);
    prodChanges = removeSubstringFromKeys('0m', prodChanges);

    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'brand': brand,
      'imei': imei,
      'color': color,
      'batteryCapacity': batteryCapacity,
      'resolution': resolution,
      'ram': ram,
      'storage': storage,
      'weight': weight,
      'addedTime': addedTime,

      'currPrice': currPrice,
      'currBuyPrice': currBuyPrice,

      'currQty': currQty,
      'currQtyReduced': currQtyReduced,

      'prodChanges': prodChanges,
      'buyHis': buyHis,
      'sellHis': sellHis,
      'allItems': allItems,// dont save it cz i dont in db (i get it when make fromjson)
    };
  }
}
