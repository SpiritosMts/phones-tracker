


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phones_tracker/_manager/myVoids.dart';
import 'package:phones_tracker/products/productsCtr.dart';

import '_manager/firebaseVoids.dart';



bool access = false;
// List<String> workSpaces = [
//
// ];
Future<void> getPrivateData()async{
  print('## getting PD(private Data) ...');
  List<DocumentSnapshot> privateData = await getDocumentsByColl(prDataColl);
  DocumentSnapshot privateDataDoc = privateData[0];// get first doc called 'private data'

  //all fields +
  access = privateDataDoc.get('access') ;
  workSpaces = List<String>.from(privateDataDoc.get('workSpaces') ?? []);
  modelValues = List<String>.from(privateDataDoc.get('models') ?? []);

  colorValues = List<String>.from(privateDataDoc.get('color') ?? []);
  storageValues = List<String>.from(privateDataDoc.get('storage') ?? []);
  ramValues = List<String>.from(privateDataDoc.get('ram') ?? []);
  phoneManufacturers = List<String>.from(privateDataDoc.get('brand') ?? []);


  print('## workSpaces= $workSpaces');
  print('## modelValues= $modelValues');
  print('## colorValues= $colorValues');


}