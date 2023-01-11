import 'dart:ffi';

import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class bookshelfOffline extends StatefulWidget {
  const bookshelfOffline({Key? key}) : super(key: key);

  @override
  State<bookshelfOffline> createState() => _bookshelfOfflineState();
}

class _bookshelfOfflineState extends State<bookshelfOffline> {
  List<Map<String, dynamic>> myData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    final data = await DatabaseHelper.getItems();

    for (var datas in data) {
      myData[1] = {
        "book_id": datas['book_id'],
        "book_name": datas['book_name'],
        "path_image": "",
        "path_file": ""
      };
    }

    print(myData);

    // setState(() {
    //   myData = data;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
