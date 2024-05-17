


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:phones_tracker/_manager/myVoids.dart';

import '_manager/firebaseVoids.dart';



bool access = false;

Future<void> getPrivateData()async{
  print('## getting PD(private Data) ...');
  List<DocumentSnapshot> privateData = await getDocumentsByColl(prDataColl);
  DocumentSnapshot privateDataDoc = privateData[0];// get first doc called 'private data'

  //all fields +
  access = privateDataDoc.get('access');



}