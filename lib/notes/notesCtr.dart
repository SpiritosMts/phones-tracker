
import 'package:flutter/material.dart';
import 'package:phones_tracker/_models/invoice.dart';
import 'package:phones_tracker/invoices/changeTotalSellDialog.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:uuid/uuid.dart';

import '../_manager/bindings.dart';
import '../_manager/firebaseVoids.dart';
import '../_manager/myUi.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import '../_models/invProd.dart';
import '../_models/note.dart';
import '../_models/product.dart';
import '../main.dart';

class NotesCtr extends GetxController {

  @override
  onInit() {
    super.onInit();
    print('## init notesCtr');
    sharedPrefs!.reload();
    Future.delayed(const Duration(milliseconds: 50), () async {
      refreshNotes();

    });
  }
  final descTec = TextEditingController();
  final clientNameTec = TextEditingController();

  List<Note> allNotes = [];

  refreshNotes() async {
    allNotes = await getAlldocsModelsFromFb<Note>( // refresh other users
        true, notesColl, (json) => Note.fromJson(json),
        localKey: '');
    update();

    allNotes.sort((a, b) {
      //order by date
      DateTime timeA = dateFormatHM.parse(a.date!);
      DateTime timeB = dateFormatHM.parse(b.date!);
      return timeB.compareTo(timeA);
    });

  }

  removeNote(note) async {
    try{

      bool accept = await showNoHeader(txt: 'are you sure you want to remove this note ?',btnOkText: 'Remove');
      if(!accept) return;

        var value = await  deleteDoc(
            docID: note.id!,
            coll: productsColl
        );


      ///----- success
      refreshNotes();
      showSnack('note removed', color: Colors.redAccent.withOpacity(0.8));

      update();

    }catch(error){
      print('## Failed to remove note : $error ');


    }
  }



  addNote() async {

    if (descTec.text.isEmpty || clientNameTec.text.isEmpty) {
      showSnack('Please fill in the fields...'.tr);
      return;
    }

    try {
      showLoading(text: 'Loading'.tr);
      String specificID = Uuid().v1();
      Note noteToAdd =  Note(
        id: specificID,
        clientName: clientNameTec.text,
        date: todayToString(showHoursNminutes: true ),
        description: descTec.text,
        type: 'Note',
        workerID: cUser.id,
        workerName: cUser.name,
        workSpace: cWs,


      );

        var value = await addDocument(
          fieldsMap: noteToAdd.toJson(),
          coll  : notesColl,
          specificID: specificID,
        );


      ///----- success--------
      Get.back(); //hide loading
      Get.back(); //hide dialog
      descTec.clear();
      clientNameTec.clear();
      refreshNotes();
     if(!descTec.text.isEmpty) showTos("You added new note".tr,color: Colors.green);


    } catch (error) {
      print("## Failed to add new note: $error");
      showTos("Failed to add new note".tr);
    }

  }


  showNoteDialog() {

    print('## show note dialog');
    return AlertDialog(
      backgroundColor: dialogBgCol,
      title: Text(
        'Add New Note'.tr,
        style: TextStyle(
          color: dialogTitleCol,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: GetBuilder<NotesCtr>(
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
                  controller: clientNameTec,
                  labelText: 'Client Name'.tr,
                  icon: Icons.person,
                ),
                SizedBox(height: 18,),

                customTextField(
                  controller: descTec,
                  labelText: 'Note Description'.tr,
                  icon: Icons.description,
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
                          addNote();
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


}
