import 'package:flutter/material.dart';
import '../widgets/leftmenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/m_allbook/book_categorie.dart';
import '../constants/colors.dart';
import '../pages/book_subCategory.dart';
import '../pages/search/search.dart';

class bookCategory extends StatefulWidget {
  const bookCategory({Key? key}) : super(key: key);

  @override
  State<bookCategory> createState() => _bookCategoryState();
}

class _bookCategoryState extends State<bookCategory> {
  List<Result?> dataBookCategory = [];
  late int uni_id;

  void getBookCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? uniLink = prefs.getString('uniLink');
    // print('URL is : ${uniLink}/categories.php?uni_id=${uniId}');

    var getBookCategory = "${uniLink}/categoriesview.php?uni_id=${uniId}";
    final uri = Uri.parse(getBookCategory);
    http.get(uri).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        setState(() {
          dataBookCategory =
              categoriesBook.fromJson(decodedData).result as List<Result?>;
        });
      } else {}
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getBookCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "หมวดหมู่หนังสือ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AnimeUI.cyan,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => searchPage()),
                );
                // showSearch(
                //   context: context,
                //   delegate: MySearchDelegate(),
                // );
              },
            ),
          ],
        ),
        drawer: PublicDrawer(),
        body: ListView.builder(
            itemCount: dataBookCategory.length,
            itemBuilder: (context, index) {
              if (dataBookCategory[index]!.bookCount.toString() != "0") {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          AssetImage('assets/images/Book-icon.png'),
                    ),
                    title: Text(
                        '${dataBookCategory[index]!.bookcateName.toString()}'),
                    // subtitle: Text(user.email),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => subCategoryList(
                          bookcate_id:
                              dataBookCategory[index]!.bookcateId.toString(),
                          bookcate_name:
                              dataBookCategory[index]!.bookcateName ?? '',
                        ),
                      ));
                    },
                  ),
                );
              } else {
                return Card();
              }
              // final book = dataBookCategory[index];
            }));
  }
}
