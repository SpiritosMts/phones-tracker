import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:phones_tracker/_models/invoice.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'bindings.dart';
import 'myVoids.dart';
import 'dart:io';




/// add DOCUMENT to fireStore
//  if specificID!='' ID will be added to 'prefs'
Future<void> addDocument(
    {required fieldsMap,
      required CollectionReference coll ,
      bool addIDField = true,
      String specificID = '',
      bool addRealTime = false,
      String docPathRealtime = '',
      Map<String, dynamic>? realtimeMap}) async {



  if (specificID != '') {
    coll.doc(specificID).set(fieldsMap).then((value) async {
      print("## DOC ADDED TO <${coll.path}>");

      //add id to doc
      if (addIDField) {
        //set id
        coll.doc(specificID).update(
          {
            ///this
            'id': specificID,
          },
          //SetOptions(merge: true),
        );
        if (addRealTime) {
          DatabaseReference serverData = database!.ref(docPathRealtime);
          await serverData.update({"$specificID": realtimeMap}).then((value) async {});
        }
      }
    }).catchError((error) {
      print("## Failed to add doc to <${coll.path}>: $error");
    });
  } else {
    coll.add(fieldsMap).then((value) async {
      print("## DOC ADDED TO <${coll.path}>");

      //add id to doc
      if (addIDField) {
        String docID = value.id;
        //set id
        coll.doc(docID).update(
          {
            ///this
            'id': docID,
          },
          //SetOptions(merge: true),
        );
        if (addRealTime) {
          DatabaseReference serverData = database!.ref(docPathRealtime);
          await serverData.update({"$docID": realtimeMap}).then((value) async {});
        }
      }
    }).catchError((error) {
      print("## Failed to add doc to <${coll.path}>: $error");
      showSnack(snapshotErrorMsg,color:Colors.black54);
      throw Exception('## Exception ');


    });
  }
}

/// UPDATE document
Future<void> updateDoc({required CollectionReference coll , required String docID, Map<String, dynamic> fieldsMap = const {}}) async {

  await coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      await coll.doc(docID).update(fieldsMap).then((value) async {
        //showSnack('doc updated'.tr);
        print('## doc updated');
        //Get.back();//cz it in dialog
      }).catchError((error) async {
        showSnack('doc failed to updated'.tr);
        print('## doc falide to updated');
        throw Exception('## Exception ');

      });
    }
  });
}


Future<List<DocumentSnapshot>> getDocumentsByColl(CollectionReference coll) async {
  List<DocumentSnapshot> documentsFound =[];

  try{
    QuerySnapshot snap = await coll.get();
    documentsFound = snap.docs; //return QueryDocumentSnapshot .data() to convert to json// or "userDoc.get('email')" for each field
  }catch(err){
    print('## Failed to get docs in coll<${coll.path}>: $err');
    throw Exception('## Exception ');
  }
  return documentsFound;
}


/// //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Future<List<T>> getAlldocsModelsFromFb<T>(bool online, CollectionReference coll, T Function(Map<String, dynamic>) fromJson,
    {String? localKey}) async {
  //print('## getting  "$localKey" from ${online? '"DB"':'"PREFS"' } ...');

  List<T> models = [];

  if (online) {
    //online
    List<DocumentSnapshot> docs = await getDocumentsByColl(coll);
    for (var doc in docs) {
      T model = fromJson(doc.data() as Map<String, dynamic>);
      models.add(model);
    }
    print('## from "DB" ## downloaded (${models.length}) models; collection <${coll.path}>');


  } else {//offline
   // models = await loadPrefsList(localKey!, fromJson) ;
    print('## from "PREFS" ## (${models.length}) models; key <${localKey}>');

  }

  return models;
}



Future<void> deleteDoc({Function()? success, required String docID,required CollectionReference coll})async {
  //if docID doesnt exist it will success to remove
  await coll.doc(docID).delete().then((value) async {
    print('## document<$docID> from <${coll.path}> deleted');
    if(success!=null) success();
    //showSnack('doc deleted'.tr, color: Colors.redAccent.withOpacity(0.8));
  }).catchError((error) async {
    print('## document<$docID> from <${coll.path}> deleting error = ${error}');
    showSnack(snapshotErrorMsg,color:Colors.black54);
    throw Exception('## Exception ');

  });

}




void deleteFromMap({coll, docID, fieldMapName, String mapKeyToDelete ='', bool withBackDialog = false, String targetInvID ='', Function()? addSuccess,}) {

  //we need either targetInvID or mapKeyToDelete to delete item from map
  print('## try deleting map in ${coll}/$docID/$fieldMapName/$mapKeyToDelete');
  if(targetInvID!='') print('## targetInvID = <$targetInvID> ');// delete map B in map A by ""value"" in map B,
  if(mapKeyToDelete!='') print('## mapKeyToDelete = <$mapKeyToDelete>');// delete map B in map A by ""key"" of map B,

  coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      try {
        Map<String, dynamic> fieldMap = documentSnapshot.get(fieldMapName);
        String keyToDelete = mapKeyToDelete;
        //search map key depending on specific value
        if (targetInvID != '') {
          for (var entry in fieldMap.entries) {
            if (entry.value['invID'] == targetInvID) {
              keyToDelete = entry.key;
            }
          }
        }

        if (fieldMap.containsKey(keyToDelete)) {
          fieldMap.remove(keyToDelete);
          if (addSuccess != null) addSuccess();
        } else {
          print('## hisTr not found or already deleted');
          return;
        }


        await coll.doc(docID).update({
          '${fieldMapName}': fieldMap,
        });

        //------- success

        print('## item from fieldMap<$fieldMapName> deleted');


      }catch(error){
        print('## ERROR: item from fieldMap <$fieldMapName> FAILED to deleted: $error');
        throw Exception('## Exception ');

      }
    } else {
      print('## doc<$docID> dont exist');
    }
  }).catchError((error) async {
    print('## ERROR: FAILED to even get  ${coll}/$docID/ : $error');
  });
}
Map<String, dynamic>  deleteFromMapLocal({mapInitial, String mapKeyToDelete ='', String targetInvID ='', Function()? addSuccess,}) {

  Map<String, dynamic> fieldMap = {};
  //we need either targetInvID or mapKeyToDelete to delete item from map
  if(targetInvID!='') print('## targetInvID = <$targetInvID> ');// delete map B in map A by ""value"" in map B,
  if(mapKeyToDelete!='') print('## mapKeyToDelete = <$mapKeyToDelete>');// delete map B in map A by ""key"" of map B,

  try {

    fieldMap = mapInitial;
    String keyToDelete = mapKeyToDelete;
    //search map key depending on specific value
    if (targetInvID != '') {
      for (var entry in fieldMap.entries) {
        if (entry.value['invID'] == targetInvID) {
          keyToDelete = entry.key;
        }
      }
    }

    print('## key To Delete = ${keyToDelete} ');


    if (fieldMap.containsKey(keyToDelete)) {
      fieldMap.remove(keyToDelete);
      if(addSuccess!= null) addSuccess();
    } else {
      print('## hisTr not found or already deleted');
    }


  }catch(error)  {
    print('## ERROR: FAILED to remove key="$mapKeyToDelete" : $error');
    throw Exception('## Exception ');

  };
  return fieldMap;
}



Future<void> addToMap({coll, docID, fieldMapName, mapToAdd, Function()? addSuccess, bool withBackDialog = false}) async{
  coll.doc(docID).get().then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      Map<String, dynamic> fieldMap = documentSnapshot.get(fieldMapName);

      //int newItemIndex = fieldMap.length ;

      //New  item to ADD
      fieldMap[getLastIndex(fieldMap, afterLast: true)] = mapToAdd;

      await coll.doc(docID).update({
        '${fieldMapName}': fieldMap,
      }).then((value) async {
        if (withBackDialog) Get.back();
        print('## item to fieldMap added');
        //showSnack('item added', color: Colors.black54);
        if(addSuccess != null) addSuccess();
      }).catchError((error) async {
        print('## item to fieldMap FAILED to added');
        showSnack(snapshotErrorMsg,color:Colors.black54);

        //showSnack('item failed to be added', color: Colors.redAccent.withOpacity(0.8));
      });
    } else {
      print('## doc<$docID> dont exist');
    }
  });
}



/// //////////////////////////////////////// MANUAL CHNAGES TEST ////////////////////////////////////////////




