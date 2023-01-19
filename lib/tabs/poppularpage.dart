import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/m_allbook/bookPopular.dart';
import '../pages/detailpage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class bookPoppular extends StatefulWidget {
  const bookPoppular({Key? key}) : super(key: key);

  @override
  State<bookPoppular> createState() => _bookPoppularState();
}

class _bookPoppularState extends State<bookPoppular> {
  final controller = ScrollController();
  int page = 1;
  List<Result?> popularBooklist = [];
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
    fetch();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (hasmore == false) {
        } else {
          fetch();
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? uniLink = prefs.getString('uniLink');
    final String? pathWebSite = prefs.getString('pathWebSite');
    int limited = 10;
    var getNewBook = "${uniLink}/book_popular.php?uni_id=${uniId}&page=$page";
    final uri = Uri.parse(getNewBook);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        popularBooklist = [
          ...popularBooklist,
          ...bookPopular.fromJson(decodedData).result as List<Result?>
        ];

        setState(() {
          int limitLength = limited * page;
          if (popularBooklist.length < limitLength) {
            hasmore = false;
          } else {
            hasmore = true;
            page++;
          }
          pathSite = pathWebSite;
          // var popularBooklist = List.from(popularBooklist)..addAll(decodedData);
        });
      } else {}
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;
    return useMobileLayout
        ? bodyContentMobile(context)
        : bodyContentTablet(context);
  }

  Padding bodyContentMobile(BuildContext context) {
    // For Mobile
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          shrinkWrap: true,
          controller: controller,
          itemCount: popularBooklist.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 8,
            mainAxisExtent: 200,
          ),
          // itemCount: popularBooklist.length,
          itemBuilder: (BuildContext ctx, index) {
            if (index < popularBooklist.length) {
              bookIdType =
                  popularBooklist[index]!.bookId.toString().substring(1, 2);
              if (bookIdType == '9') {
                imageUrl = popularBooklist[index]!.imgLink.toString();
                popularBooklist[index]!.imgLink =
                    imageUrl.replaceAll("http://www.2ebook.com/new", pathSite);
              }
              return Container(
                //borderRadius: BorderRadius.circular(20),
                child: (popularBooklist[index]!.bookDesc != null &&
                        popularBooklist[index]!.bookId != '0')
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => detailPage(
                                      bookId:
                                          popularBooklist[index]!.bookId ?? '',
                                      bookDesc:
                                          popularBooklist[index]!.bookDesc ??
                                              '',
                                      bookshelfId:
                                          popularBooklist[index]!.bookshelfId ??
                                              '',
                                      bookPrice:
                                          popularBooklist[index]!.bookPrice ??
                                              '',
                                      bookTitle:
                                          popularBooklist[index]!.bookTitle ??
                                              '',
                                      bookAuthor:
                                          popularBooklist[index]!.bookAuthor ??
                                              '',
                                      bookNoOfPage: popularBooklist[index]!
                                              .bookNoOfPage ??
                                          '',
                                      booktypeName: popularBooklist[index]!
                                              .booktypeName ??
                                          '',
                                      publisherName: popularBooklist[index]!
                                              .publisherName ??
                                          '',
                                      bookIsbn:
                                          popularBooklist[index]!.bookIsbn ??
                                              '',
                                      bookcateId: '', // No data
                                      bookcateName: popularBooklist[index]!
                                              .bookcateName ??
                                          '',
                                      onlinetype:
                                          popularBooklist[index]!.onlinetype ??
                                              '',
                                      t2Id: '', // No data
                                      imgLink:
                                          popularBooklist[index]!.imgLink ?? '',
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
                                        popularBooklist[index]!
                                            .imgLink
                                            .toString(),
                                        height: 150,
                                        width: 200,
                                        fit: BoxFit.fitWidth,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 160, left: 20),
                                        height: 30,
                                        width: 90,
                                        child: Stack(
                                          children: <Widget>[
                                            Center(
                                                child: Text(
                                              popularBooklist[index]!
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
    );
  }

  Padding bodyContentTablet(BuildContext context) {
    // For Tablet
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          shrinkWrap: true,
          controller: controller,
          itemCount: popularBooklist.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 80,
            crossAxisSpacing: 8,
            mainAxisExtent: 370,
          ),
          // itemCount: popularBooklist.length,
          itemBuilder: (BuildContext ctx, index) {
            if (index < popularBooklist.length) {
              bookIdType =
                  popularBooklist[index]!.bookId.toString().substring(1, 2);
              if (bookIdType == '9') {
                imageUrl = popularBooklist[index]!.imgLink.toString();
                popularBooklist[index]!.imgLink =
                    imageUrl.replaceAll("http://www.2ebook.com/new", pathSite);
              }
              return Container(
                //borderRadius: BorderRadius.circular(20),
                child: (popularBooklist[index]!.bookDesc != null &&
                        popularBooklist[index]!.bookId != '0')
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => detailPage(
                                      bookId:
                                          popularBooklist[index]!.bookId ?? '',
                                      bookDesc:
                                          popularBooklist[index]!.bookDesc ??
                                              '',
                                      bookshelfId:
                                          popularBooklist[index]!.bookshelfId ??
                                              '',
                                      bookPrice:
                                          popularBooklist[index]!.bookPrice ??
                                              '',
                                      bookTitle:
                                          popularBooklist[index]!.bookTitle ??
                                              '',
                                      bookAuthor:
                                          popularBooklist[index]!.bookAuthor ??
                                              '',
                                      bookNoOfPage: popularBooklist[index]!
                                              .bookNoOfPage ??
                                          '',
                                      booktypeName: popularBooklist[index]!
                                              .booktypeName ??
                                          '',
                                      publisherName: popularBooklist[index]!
                                              .publisherName ??
                                          '',
                                      bookIsbn:
                                          popularBooklist[index]!.bookIsbn ??
                                              '',
                                      bookcateId: '', // No data
                                      bookcateName: popularBooklist[index]!
                                              .bookcateName ??
                                          '',
                                      onlinetype:
                                          popularBooklist[index]!.onlinetype ??
                                              '',
                                      t2Id: '', // No data
                                      imgLink:
                                          popularBooklist[index]!.imgLink ?? '',
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
                                        popularBooklist[index]!
                                            .imgLink
                                            .toString(),
                                        height: 270,
                                        width: 200,
                                        fit: BoxFit.fitWidth,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 260, left: 20),
                                        height: 90,
                                        width: 180,
                                        child: Stack(
                                          children: <Widget>[
                                            Center(
                                                child: Text(
                                              popularBooklist[index]!
                                                  .bookDesc
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 20,
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
    );
  }
}
