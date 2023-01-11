// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../generated/locale_keys.g.dart';
import '../pages/homepage.dart';
import '../pages/bookshelf.dart';
import '../pages/book_publisher.dart';
import '../pages/book_category.dart';
import '../constants/colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../pages/bookshelfOffline.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.selectedPage}) : super(key: key);
  int selectedPage;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool displayProcessLoadPdf = false;
  double percentNumber = 0;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  List<Widget> _widgetList = [
    HomePage(),
    bookshelfOffline(),
    bookCategory(),
    bookPublisher(),
  ];

  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    index = widget.selectedPage;
    GetConnecttivity();
  }

  Future GetConnecttivity() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      setState(() {
        if (isDeviceConnected) {
          _widgetList = [
            HomePage(),
            bookshelf(),
            bookCategory(),
            bookPublisher(),
          ];
        } else {
          _widgetList = [
            HomePage(),
            bookshelfOffline(),
            bookCategory(),
            bookPublisher(),
          ];
        }

        isDeviceConnected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter layout demo',
      home: Container(
          height: kBottomNavigationBarHeight * 1,
          decoration: BoxDecoration(
            color: AnimeUI.background,
            boxShadow: [
              BoxShadow(
                spreadRadius: 7.5,
                blurRadius: 15,
                color: AnimeUI.cyan.withOpacity(.45),
              ),
            ],
          ),
          // padding: const EdgeInsets.only(top: 5),
          child: WillPopScope(
            child: Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    backgroundColor: Colors.white,
                    label: LocaleKeys.menu_mainpage.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark),
                    backgroundColor: Colors.white,
                    label: LocaleKeys.menu_Bookshelf.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    backgroundColor: Colors.white,
                    label: LocaleKeys.menu_category.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fax),
                    backgroundColor: Colors.white,
                    label: LocaleKeys.menu_publisher.tr(),
                  ),
                ],
                selectedItemColor: AnimeUI.cyan,
                unselectedItemColor: Colors.black,
                type: BottomNavigationBarType.fixed,
                currentIndex: index,
                onTap: (i) {
                  setState(() {
                    index = i;
                  });
                },
              ),
              body: _widgetList[index],
            ),
            onWillPop: () => _clickForExit(context),
          )),
    );
  }

  Future<bool> _clickForExit(BuildContext context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(LocaleKeys.exit.tr()),
            content: Text(LocaleKeys.exitDetail.tr()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(LocaleKeys.no.tr()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(LocaleKeys.yes.tr()),
              ),
            ],
          );
        });

    return exitApp ?? false;
  }
}
