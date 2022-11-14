// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../pages/homepage.dart';
import '../pages/bookshelf.dart';
import '../pages/book_publisher.dart';
import '../pages/book_category.dart';
import '../constants/colors.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.selectedPage}) : super(key: key);
  int selectedPage;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> _widgetList = [
    HomePage(),
    bookshelf(),
    bookCategory(),
    bookPublisher(),
  ];
  int index = 0;
  @override
  void initState() {
    // TODO: implement initState

    index = widget.selectedPage;
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
        padding: const EdgeInsets.only(top: 5),
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                backgroundColor: Colors.white,
                label: "หน้าหลัก",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                backgroundColor: Colors.white,
                label: "ชั้นหนังสือ",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                backgroundColor: Colors.white,
                label: "หมวดหมู่",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fax),
                backgroundColor: Colors.white,
                label: "สำนักพิมพ์",
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
      ),
    );
  }
}
