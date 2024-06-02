import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:phones_tracker/_manager/bindings.dart';
import 'package:phones_tracker/_manager/myVoids.dart';
import 'package:phones_tracker/_models/product.dart';
import 'package:phones_tracker/privateData.dart';
import 'package:phones_tracker/products/productsCtr.dart';
import 'package:get/get.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/myUi.dart';
import '../_manager/styles.dart';
import '../products/productAdd.dart';

//########################################################################
//########################################################################

class WorkSpacesEdit extends StatefulWidget {
  const WorkSpacesEdit({super.key});

  @override
  State<WorkSpacesEdit> createState() => _WorkSpacesEditState();
}

class _WorkSpacesEditState extends State<WorkSpacesEdit> {
  final newWorkSpc = TextEditingController();

  addWorkSpace() async {
    String newWrk = newWorkSpc.text;

    if (newWrk.isNotEmpty && !workSpaces.contains(newWrk)) {


      try {

        await prDataColl.doc('prData').update({
          'workSpaces': FieldValue.arrayUnion([newWrk]),
        });


        // Get all documents in the collection
        QuerySnapshot querySnapshot = await productsColl.get();

        // // Loop through each document
        querySnapshot.docs.forEach((doc) async {
          // Get the current value of currQty map
          Map<String, dynamic> currQty = doc.get('currQty') ?? {}; // If currQty is null, initialize it as an empty map

          // Update the map with the new item {'x': 0}
          currQty[newWrk] = 0;

          // Update the document with the modified currQty map
          await productsColl.doc(doc.id).update({
            'currQty': currQty,
          });
        });


        getPrivateData();
        prdCtr.refreshProducts();

        Get.back();
      } catch (error) {
        print('## Error adding work Space: $error');
      }

    } else {
      showSnack('please verify the workSpace name');
    }
  }

  deleteWorkSpace(String workspace) async {
    bool accept = await showNoHeader(txt: 'are you sure you want to remove "${workspace}" workSpace ?',btnOkText: 'Remove');
    if(!accept) return;

    if (workspace.isNotEmpty && workSpaces.contains(workspace)) {
      try {
        // Remove the workspace from the Firestore document
        await prDataColl.doc('prData').update({
          'workSpaces': FieldValue.arrayRemove([workspace]),
        });

        // Get all documents in the products collection
        QuerySnapshot querySnapshot = await productsColl.get();

        // Loop through each document to update the currQty map
        querySnapshot.docs.forEach((doc) async {
          // Get the current value of currQty map
          Map<String, dynamic> currQty = doc.get('currQty') ?? {};

          // Remove the workspace key from the currQty map
          currQty.remove(workspace);

          // Update the document with the modified currQty map
          await productsColl.doc(doc.id).update({
            'currQty': currQty,
          });
        });

        // Refresh the local data
        getPrivateData();
        prdCtr.refreshProducts();
        Get.back();
      } catch (error) {
        print('## Error removing workspace: $error');
      }
    } else {
      showSnack('Workspace not found or invalid.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarBgColor,
        title: Text(
          'Work Spaces',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: appBarTitleColor,
          ),
        ),
        bottom: appBarUnderline(),
      ),
      body: Container(
        color: bgCol, //bg of products
        child: GetBuilder<ProductsCtr>(
          initState: (_) {
            Future.delayed(const Duration(milliseconds: 500), () {
              prdCtr.update();
            });
          },
          dispose: (_) {},
          builder: (_) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Text(
                            textAlign: TextAlign.start,
                            'Work Spaces:'.tr,
                            style: const TextStyle(
                              fontSize: 20,
                              color: orangeCol,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          workSpaces.length,
                              (index) {
                            return Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        workSpaces[index],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: transparentTextCol,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close, color: Colors.red),
                                      onPressed: () {
                                        deleteWorkSpace(workSpaces[index]);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      phonePropField(label: 'New WorkSpace', controller: newWorkSpc),
                      SizedBox(
                        height: 35,
                      ),
                      SizedBox(
                        width: 100,
                        child: TextButton(
                          style: filledBtnStyle(),
                          onPressed: () async {
                            addWorkSpace();
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(color: dialogBtnOkTextCol),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
