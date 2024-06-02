
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phones_tracker/_manager/bindings.dart';
import 'package:phones_tracker/_manager/myUi.dart';
import 'package:phones_tracker/_manager/myVoids.dart';
import 'package:phones_tracker/notes/notesCtr.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/styles.dart';
import '../_models/note.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgCol,
      child: GetBuilder<NotesCtr>(builder: (_) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(height: 20,),
                  Expanded(
                    child: Container(
                      child:noteCtr.allNotes.isNotEmpty? ListView.builder(
                        //  physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                            top: 5,
                            bottom: 20,
                            right: 0,
                            left: 0,
                          ),
                          //itemExtent: 100,// card height
                          itemCount: noteCtr.allNotes.length,
                          itemBuilder: (BuildContext context, int index) {
                            Note req = (noteCtr.allNotes[index]);
                            if(req.workSpace==cWs || cUser.isAdmin){
                              return noteCard(req, index);

                            }else{
                              return Container();
                            }
                          }
                      ):Padding(padding: EdgeInsets.only(left:30.w),child: elementNotFound('no notes found'.tr),),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                right: 15,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0, right: 0, left: 0),

                  child: ElevatedButton(
                    style: filledBtnStyle(),
                    onPressed: () {
                      showAnimDialog(noteCtr.showNoteDialog());
                    },
                    child: Text(
                      "Add Note".tr,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),

            ],
          ),
        );
      }
      ),
    );
  }
}
