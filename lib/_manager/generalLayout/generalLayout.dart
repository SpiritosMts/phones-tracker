import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:phones_tracker/affected/affected.dart';
import 'package:phones_tracker/profile/profileScreen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../admin/editWorkSpaces.dart';
import '../../invoices/invoiceView(home).dart';
import '../../notes/notesList.dart';
import '../../products/categs.dart';
import '../../products/searchInventory.dart';
import '../../stats/stats.dart';
import '../bindings.dart';
import '../myVoids.dart';
import '../settings/settings.dart';
import '../styles.dart';
import '../../products/productsView.dart';
import 'generalLayoutCtr.dart';

class GeneralLayout extends StatefulWidget {
  const GeneralLayout({super.key});

  @override
  State<GeneralLayout> createState() => _GeneralLayoutState();
}

class _GeneralLayoutState extends State<GeneralLayout> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      StatsScreen(), //invoices
      SearchProductsView(), //products
      NotesList(),
      ProfileScreen() //settings
    ];
  }


  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.show_chart),
        title: ("Stats"),
        activeColorPrimary: navBarActive,
        inactiveColorPrimary: navBarDesactive,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(LineIcons.search),
        title: ("Search"),
        activeColorPrimary: navBarActive,
        inactiveColorPrimary: navBarDesactive,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(LineIcons.pen),
        title: ("Notes"),
        activeColorPrimary: navBarActive,
        inactiveColorPrimary: navBarDesactive,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: navBarActive,
        inactiveColorPrimary: navBarDesactive,
      ),
    ];
  }



  /// **************************************************************************************
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LayoutCtr>(
        initState: (_) {
          layCtr.onScreenSelected(0);
        },
        dispose: (_) {},
        builder: (_) {
          return Scaffold(
            key: layCtr.scaffoldKey, // Set the scaffold key

            drawer: Drawer(

              width: 63.w,
              child: ListView(
                padding: EdgeInsets.zero,

                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(.7),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 5,),

                        CircleAvatar(
                          radius: 40, // radius of the circle
                          backgroundImage: AssetImage('assets/images/worker.png'), // replace with your asset image path
                        ),
                        SizedBox(height: 10,),
                        Text(
                          cUser.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 4,),

                        Text(
                          cUser.isAdmin ? 'Admin':'Worker',
                          textAlign:TextAlign.start ,
                          style: TextStyle(

                            color: Colors.white,
                            fontSize: 10,

                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_cart_outlined),
                    title: Text('Sales',style: TextStyle(color: primaryColor),),
                    onTap: () {
                      Get.to(()=>InvoicesView());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_basket_rounded),
                    title: Text('Inventory',style: TextStyle(color: primaryColor),),
                    onTap: () {
                      Get.to(()=>Categs());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.devices),
                    title: Text('Deffected Devices',style: TextStyle(color: primaryColor),),
                    onTap: () {
                      Get.to(()=>AffectedDevices());
                    },
                  ),
                if(cUser.isAdmin)  ListTile(
                    leading: Icon(Icons.location_city),
                    title: Text('Work Spaces',style: TextStyle(color: primaryColor),),
                    onTap: () {
                      Get.to(()=>WorkSpacesEdit());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings',style: TextStyle(color: primaryColor),),
                    onTap: () {
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log Out',style: TextStyle(color: primaryColor),),
                    onTap: () {
                      authCtr.signOutUser(shouldGoLogin: true);

                    },
                  ),
                ],
              ),
            ),

            appBar: AppBar(
              centerTitle: true,
              backgroundColor: appBarBgColor,
              title: Text(
                layCtr.appBarText.tr,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: appBarTitleColor,
                ),
              ),
              bottom: appBarUnderline(),
              leading: layCtr.leading,
              actions: layCtr.appBarBtns,
            ),

            ///******************************************************
            // EasySearchBar(
            //     title: Text(
            //       layCtr.appBarText.tr,style: TextStyle(
            //       fontWeight: FontWeight.w500,
            //       color: appBarTitleColor,
            //      ),
            //     ),
            //
            //
            //   isFloating: true,
            //   openOverlayOnSearch: true,
            //   backgroundColor:appBarBgColor ,
            //   //  bottom: appBarUnderline(),
            //     leading: layCtr.leading,
            //      actions: layCtr.appBarBtns,
            //     onSearch: (text) {
            //        prdCtr.runProdFilter(searchText: text);
            //     }
            // ),
            ///******************************************************

            // AppBar(
            //
            //   backgroundColor: appBarBgColor,
            //   title: TextFormField(
            //    // focusNode: _focusNode,
            //
            //   controller: prdCtr.searchTec,
            //     decoration: InputDecoration(
            //       hintText: 'Search...',
            //       hintStyle: TextStyle(color: transparentTextCol),
            //       filled: true,
            //       fillColor: appBarBgColor,
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //         borderSide: BorderSide.none,
            //       ),
            //     ),
            //     style: TextStyle(color: transparentTextCol),
            //     onChanged: (text) {
            //       prdCtr.runProdFilter(searchText: text);
            //     },
            //   ),
            //
            //   actions: [
            //     IconButton(
            //       icon: Icon(Icons.search,color: appBarButtonsCol,),
            //       onPressed: () {
            //        // _focusNode.requestFocus();
            //       },
            //     ),
            //   ],
            //   bottom: appBarUnderline(),
            // ),

            ///*****************************************************
            // AppBar(
            //   leading: _isSearching ? const BackButton() : Container(),
            //   title: _isSearching ? _buildSearchField() : Container(),
            //   actions: _buildActions(),
            // ),
            ///*****************************************************
            body: PersistentTabView(
              selectedTabScreenContext: (ctx) {},
              context,
              controller: _controller,
              screens: _buildScreens(),
              items: _navBarsItems(),
              backgroundColor: navBarBgColor,
              onItemSelected:(i){
                layCtr.onScreenSelected(i);
              },

              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(10.0),
                colorBehindNavBar: Colors.white,
              ),
              popActionScreens: PopActionScreensType.all,

              // onWillPop: (_)  async{
              //
              //   return false;
              // },
              // handleAndroidBackButtonPress: true,
              //
              //
              // popAllScreensOnTapOfSelectedTab: false,
              //
              // confineInSafeArea: true,
              // resizeToAvoidBottomInset: false,
              // stateManagement: true,
              // hideNavigationBarWhenKeyboardShows: false,
              // hideNavigationBar: false,

              itemAnimationProperties: ItemAnimationProperties(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimation(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              bottomScreenMargin: 55,
              navBarHeight: 55,

              navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
            ),
          );
        });
  }
}
