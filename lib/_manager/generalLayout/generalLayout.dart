
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../invoices/invoiceView(home).dart';
import '../../notes/notesList.dart';
import '../bindings.dart';
import '../settings/settings.dart';
import '../styles.dart';
import '../../products/productsView.dart';
import 'generalLayoutCtr.dart';
import 'package:easy_search_bar/easy_search_bar.dart';


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
      InvoicesView(),//invoices
      ProductsView(),//products
      NotesList(),
      SettingsView()//settings
    ];
  }
  final FocusNode _focusNode = FocusNode();

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.newspaper),
        title: ("Invoices"),

        activeColorPrimary: navBarActive,
        inactiveColorPrimary: navBarDesactive,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(LineIcons.shoppingCart),
        title: ("Products"),
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
        icon: Icon(Icons.settings),
        title: ("Settings"),
        activeColorPrimary: navBarActive,
        inactiveColorPrimary: navBarDesactive,
      ),
    ];
  }


  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
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
          appBar:
          AppBar(
            centerTitle: true,
            backgroundColor: appBarBgColor,
            title: Text(
              layCtr.appBarText.tr,style: TextStyle(
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

            selectedTabScreenContext: (ctx){

            },
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            backgroundColor: navBarBgColor,
            onItemSelected:layCtr.onScreenSelected,

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
      }
    );
  }
}
