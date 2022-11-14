import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/m_search/search.dart';
import '../../pages/detailpage.dart';
import '../../pages/search/search_loading.dart';
import '../../pages/mainpage.dart';
import '../../constants/colors.dart';

class searchPage extends StatefulWidget {
  const searchPage({Key? key}) : super(key: key);

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  TextEditingController t = TextEditingController();
  List<Result?> dataBookSearch = [];

  // String st(String s) {
  //   int count = 0;
  //   String ans = "";
  //   for (int i = 0; i < s.length; i++) {
  //     if (count == 3) {
  //       break;
  //     }
  //     if (s[i] == ' ') {
  //       count++;
  //     }
  //     ans = ans + s[i];
  //   }
  //   return ans + "...";
  // }

  // void getdata() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String? uniId = prefs.getString('uniId');

  //   var getPublisher =
  //       "https://www.2ebook.com/new/2ebook_mobile/search.php?search=${t}&page=1&uni_id=${uniId}";
  //   final uri = Uri.parse(getPublisher);
  //   http.get(uri).then((response) async {
  //     if (response.statusCode == 200) {
  //       final responseBody = response.body;
  //       final decodedData = jsonDecode(responseBody);

  //       setState(() {
  //         dataBookSearch =
  //             searchBook.fromJson(decodedData).result as List<Result?>;
  //       });
  //     } else {}
  //   }).catchError((err) {
  //     debugPrint('=========== $err =============');
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 100),
                Text(
                  '2EBOOK SEARCH!',
                  style: TextStyle(
                    color: AnimeUI.cyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Find your book in my Library.',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: t,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ค้นหาหนังสือ.',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  // onPressed: () {
                  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //     return searchloading(text: t.text);
                  //     // return searchloading();
                  //   }));
                  // },
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => searchloading(text: t.text)),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: AnimeUI.cyan),
                  // splashColor: Color(0xfff012AC0),
                  // color: AnimeUI.cyan,
                  child: Text(
                    "               SEARCH               ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                // SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Container(
                //     padding: EdgeInsets.all(20),
                //     decoration: BoxDecoration(
                //         color: AnimeUI.cyan,
                //         borderRadius: BorderRadius.circular(12)),
                //     child: Center(
                //       child: Text(
                //         'SEARCH',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 18,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
