import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/m_allbook/book_subCategorie.dart';
import '../pages/detailpage.dart';
import '../constants/colors.dart';

class subCategoryList extends StatefulWidget {
  final String bookcate_id;
  final String bookcate_name;
  const subCategoryList(
      {Key? key, required this.bookcate_id, required this.bookcate_name});

  @override
  State<subCategoryList> createState() => _subCategoryListState(
      bookcateId: bookcate_id, bookcateName: bookcate_name);
}

class _subCategoryListState extends State<subCategoryList> {
  String bookcateId;
  String bookcateName;
  _subCategoryListState({required this.bookcateId, required this.bookcateName});

  final controller = ScrollController();
  int page = 1;
  List<Result?> subCategorylist = [];
  List<String> databook = [];
  bool hasmore = true;
  var bookIdType;
  var pathSite;
  var imageUrl;
  var imageLocalFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch(bookcateId);

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch(bookcateId);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future fetch(bookcate_id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? uniLink = prefs.getString('uniLink');
    final String? pathWebSite = prefs.getString('pathWebSite');
    const limited = 10;
    // print('page is $page');
    var getNewBook =
        "${uniLink}/categoriesbooks.php?uni_id=${uniId}&bookcate_id=${bookcateId}&page=${page}";
    final uri = Uri.parse(getNewBook);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        subCategorylist = [
          ...subCategorylist,
          ...subCategory_books.fromJson(decodedData).result as List<Result?>
        ];
        setState(() {
          page++;

          if (subCategorylist.length < limited) {
            hasmore = false;
          }
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "หมวดหมู่หนังสือ${bookcateName}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AnimeUI.cyan,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            shrinkWrap: true,
            controller: controller,
            itemCount: subCategorylist.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 8,
              mainAxisExtent: 200,
            ),
            // itemCount: popularBooklist.length,
            itemBuilder: (BuildContext ctx, index) {
              if (index < subCategorylist.length) {
                bookIdType =
                    subCategorylist[index]!.bookId.toString().substring(1, 2);
                if (bookIdType == '9') {
                  imageUrl = subCategorylist[index]!.imgLink.toString();
                  subCategorylist[index]!.imgLink = imageUrl.replaceAll(
                      "http://www.2ebook.com/new", pathSite);
                }

                return Container(
                  //borderRadius: BorderRadius.circular(20),
                  child: (subCategorylist[index]!.bookDesc != null &&
                          subCategorylist[index]!.bookId != '0')
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => detailPage(
                                        bookId:
                                            subCategorylist[index]!.bookId ??
                                                '',
                                        bookDesc:
                                            subCategorylist[index]!.bookDesc ??
                                                '',
                                        bookshelfId: subCategorylist[index]!
                                                .bookshelfId ??
                                            '',
                                        bookPrice:
                                            subCategorylist[index]!.bookPrice ??
                                                '',
                                        bookTitle:
                                            subCategorylist[index]!.bookTitle ??
                                                '',
                                        bookAuthor: subCategorylist[index]!
                                                .bookAuthor ??
                                            '',
                                        bookNoOfPage: subCategorylist[index]!
                                                .bookNoOfPage ??
                                            '',
                                        booktypeName: subCategorylist[index]!
                                                .booktypeName ??
                                            '',
                                        publisherName: subCategorylist[index]!
                                                .publisherName ??
                                            '',
                                        bookIsbn:
                                            subCategorylist[index]!.bookIsbn ??
                                                '',
                                        bookcateId: '', // No data
                                        bookcateName: subCategorylist[index]!
                                                .bookcateName ??
                                            '',
                                        onlinetype: subCategorylist[index]!
                                                .onlinetype ??
                                            '',
                                        t2Id: '', // No data
                                        imgLink:
                                            subCategorylist[index]!.imgLink ??
                                                '',
                                      )),
                            );
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                  elevation: 10.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Image.network(
                                          subCategorylist[index]!
                                              .imgLink
                                              .toString(),
                                          height: 150,
                                          width: 200,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 160, left: 20),
                                          height: 30,
                                          width: 90,
                                          child: Stack(
                                            children: <Widget>[
                                              Center(
                                                  child: Text(
                                                subCategorylist[index]!
                                                    .bookDesc
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      : Image.asset('assets/images/logo_2ebook.png'),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                      child: hasmore
                          ? const CircularProgressIndicator()
                          : const Text('')),
                );
              }
            }),
      ),
    );
  }
}
