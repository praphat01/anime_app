import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/locale_keys.g.dart';
import '../../models/m_search/search.dart';
import '../../pages/detailpage.dart';
import '../../constants/colors.dart';
import '../search/search.dart';

class searchloading extends StatefulWidget {
  var text;
  searchloading({@required this.text});

  @override
  State<searchloading> createState() => _searchloadingState();
}

class _searchloadingState extends State<searchloading> {
  List<Result?> dataBookSearch = [];
  var dataBook;
  var bookIdType;
  var pathSite;
  var imageUrl;
  var imageLocalFile;
  final controller = ScrollController();
  int page = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        getdata();
      }
    });
  }

  void getdata() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? uniLink = prefs.getString('uniLink');
    final String? pathWebSite = prefs.getString('pathWebSite');
    var getPublisher =
        "${uniLink}/search.php?search=${widget.text}&page=$page&uni_id=${uniId}";
    final uri = Uri.parse(getPublisher);
    http.get(uri).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        dataBookSearch = [
          ...dataBookSearch,
          ...searchBook.fromJson(decodedData).result as List<Result?>
        ];

        setState(() {
          page++;
          pathSite = pathWebSite;
        });
      } else {}
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.search_result.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AnimeUI.cyan,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      // backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.white,
          ),
          Expanded(
            child: ListView.builder(
                controller: controller,
                itemCount: dataBookSearch.length,
                itemBuilder: (context, index) {
                  bookIdType =
                      dataBookSearch[index]!.bookId.toString().substring(1, 2);
                  if (bookIdType == '9') {
                    imageUrl = dataBookSearch[index]!.imgLink.toString();
                    dataBookSearch[index]!.imgLink = imageUrl.replaceAll(
                        "http://www.2ebook.com/new", pathSite);
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: (Container(
                      padding: EdgeInsets.all(10),
                      height: 270,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 239, 239, 239),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 210,
                            width: 140,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(dataBookSearch[index]!
                                        .imgLink
                                        .toString()),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Flexible(
                                  child: Text(
                                    dataBookSearch[index]!.bookTitle.toString(),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    'ผู้แต่ง : ${dataBookSearch[index]!.bookAuthor.toString()}',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    'สำนักพิมพ์ : ${dataBookSearch[index]!.publisherName.toString()}',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // getisbn(index);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => detailPage(
                                                bookId: dataBookSearch[index]!
                                                        .bookId ??
                                                    '',
                                                bookDesc: dataBookSearch[index]!
                                                        .bookDesc ??
                                                    '',
                                                bookshelfId:
                                                    dataBookSearch[index]!
                                                            .bookshelfId ??
                                                        '',
                                                bookPrice:
                                                    dataBookSearch[index]!
                                                            .bookPrice ??
                                                        '',
                                                bookTitle:
                                                    dataBookSearch[index]!
                                                            .bookTitle ??
                                                        '',
                                                bookAuthor:
                                                    dataBookSearch[index]!
                                                            .bookAuthor ??
                                                        '',
                                                bookNoOfPage:
                                                    dataBookSearch[index]!
                                                            .bookNoOfPage ??
                                                        '',
                                                booktypeName:
                                                    dataBookSearch[index]!
                                                            .booktypeName ??
                                                        '',
                                                publisherName:
                                                    dataBookSearch[index]!
                                                            .publisherName ??
                                                        '',
                                                bookIsbn: dataBookSearch[index]!
                                                        .bookIsbn ??
                                                    '',
                                                bookcateId: '', // No data
                                                bookcateName:
                                                    dataBookSearch[index]!
                                                            .bookcateName ??
                                                        '',
                                                onlinetype:
                                                    dataBookSearch[index]!
                                                            .onlinetype ??
                                                        '',
                                                t2Id: '', // No data
                                                imgLink: dataBookSearch[index]!
                                                        .imgLink ??
                                                    '',
                                              )),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AnimeUI.cyan),
                                  // color: AnimeUI.cyan,
                                  child: Text(
                                    LocaleKeys.details.tr(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  );
                }),
          )
        ],
      ),
    );
  }
}
