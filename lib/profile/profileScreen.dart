
import 'package:flutter/material.dart';
import 'package:phones_tracker/_manager/styles.dart';

import '../_manager/myVoids.dart';


class ProfileScreen extends StatefulWidget {

  ProfileScreen();

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: bgCol,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: AlignmentDirectional.center,
                child: CircleAvatar(
                  radius: 50, // radius of the circle
                  backgroundImage: AssetImage('assets/images/worker.png'), // replace with your asset image path
                ),
              ),
            ),
            SizedBox(height: 10,),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Name',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,fontSize: 20),),
              ),
              subtitle: Text(cUser.name,style: TextStyle(color: transparentTextCol,fontWeight: FontWeight.w400,fontSize: 15 ),),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Email', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 20)),
              ),
              subtitle: Text(cUser.email, style: TextStyle(color: transparentTextCol, fontWeight: FontWeight.w400, fontSize: 15)),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Phone', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 20)),
              ),
              subtitle: Text(cUser.phone, style: TextStyle(color: transparentTextCol, fontWeight: FontWeight.w400, fontSize: 15)),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Workspace', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 20)),
              ),
              subtitle: Text(cUser.workSpace, style: TextStyle(color: transparentTextCol, fontWeight: FontWeight.w400, fontSize: 15)),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Join Time', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 20)),
              ),
              subtitle: Text(cUser.joinTime, style: TextStyle(color: transparentTextCol, fontWeight: FontWeight.w400, fontSize: 15)),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Is Admin', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 20)),
              ),
              subtitle: Text(cUser.isAdmin ? 'Yes' : 'No', style: TextStyle(color: transparentTextCol, fontWeight: FontWeight.w400, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}