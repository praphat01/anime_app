import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/m_allbook/book_recommended.dart';
import '../pages/detailpage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class bookRecommended extends StatefulWidget {
  const bookRecommended({Key? key}) : super(key: key);

  @override
  State<bookRecommended> createState() => _bookRecommendedState();
}

class _bookRecommendedState extends State<bookRecommended> {
  final controller = ScrollController();
  int page = 1;
  List<Result?> recommendedBooklist = [];
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
        fetch();
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
    // print('User id is : ${uniId}');
    const limited = 10;
    var getRecommendUrl =
        "${uniLink}/book_recommended.php?uni_id=${uniId}&page=$page";
    final uri = Uri.parse(getRecommendUrl);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        recommendedBooklist = [
          ...recommendedBooklist,
          ...book_Recommended.fromJson(decodedData).result as List<Result?>
        ];

        setState(() {
          page++;

          if (recommendedBooklist.length < limited) {
            hasmore = false;
          }
          pathSite = pathWebSite;
          // var recommendedBooklist = List.from(recommendedBooklist)..addAll(decodedData);
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
    // For mobile
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          shrinkWrap: true,
          controller: controller,
          itemCount: recommendedBooklist.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 8,
            mainAxisExtent: 200,
          ),
          // itemCount: popularBooklist.length,
          itemBuilder: (BuildContext ctx, index) {
            if (index < recommendedBooklist.length) {
              bookIdType =
                  recommendedBooklist[index]!.bookId.toString().substring(1, 2);
              if (bookIdType == '9') {
                imageUrl = recommendedBooklist[index]!.imgLink.toString();
                recommendedBooklist[index]!.imgLink =
                    imageUrl.replaceAll("http://www.2ebook.com/new", pathSite);
              }
              return Container(
                //borderRadius: BorderRadius.circular(20),
                child: (recommendedBooklist[index]!.bookDesc != null &&
                        recommendedBooklist[index]!.bookId != '0')
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => detailPage(
                                      bookId:
                                          recommendedBooklist[index]!.bookId ??
                                              '',
                                      bookDesc: recommendedBooklist[index]!
                                              .bookDesc ??
                                          '',
                                      bookshelfId: recommendedBooklist[index]!
                                              .bookshelfId ??
                                          '',
                                      bookPrice: recommendedBooklist[index]!
                                              .bookPrice ??
                                          '',
                                      bookTitle: recommendedBooklist[index]!
                                              .bookTitle ??
                                          '',
                                      bookAuthor: recommendedBooklist[index]!
                                              .bookAuthor ??
                                          '',
                                      bookNoOfPage: recommendedBooklist[index]!
                                              .bookNoOfPage ??
                                          '',
                                      booktypeName: recommendedBooklist[index]!
                                              .booktypeName ??
                                          '',
                                      publisherName: recommendedBooklist[index]!
                                              .publisherName ??
                                          '',
                                      bookIsbn: recommendedBooklist[index]!
                                              .bookIsbn ??
                                          '',
                                      bookcateId: '', // No data
                                      bookcateName: recommendedBooklist[index]!
                                              .bookcateName ??
                                          '',
                                      onlinetype: recommendedBooklist[index]!
                                              .onlinetype ??
                                          '',
                                      t2Id: '', // No data
                                      imgLink:
                                          recommendedBooklist[index]!.imgLink ??
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
                                        recommendedBooklist[index]!
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
                                              recommendedBooklist[index]!
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
                // child: Center(
                //     child: hasmore
                //         ? const CircularProgressIndicator()
                //         : const Text('')),
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
          itemCount: recommendedBooklist.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 80,
            crossAxisSpacing: 8,
            mainAxisExtent: 370,
          ),
          // itemCount: popularBooklist.length,
          itemBuilder: (BuildContext ctx, index) {
            if (index < recommendedBooklist.length) {
              bookIdType =
                  recommendedBooklist[index]!.bookId.toString().substring(1, 2);
              if (bookIdType == '9') {
                imageUrl = recommendedBooklist[index]!.imgLink.toString();
                recommendedBooklist[index]!.imgLink =
                    imageUrl.replaceAll("http://www.2ebook.com/new", pathSite);
              }
              return Container(
                //borderRadius: BorderRadius.circular(20),
                child: (recommendedBooklist[index]!.bookDesc != null &&
                        recommendedBooklist[index]!.bookId != '0')
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => detailPage(
                                      bookId:
                                          recommendedBooklist[index]!.bookId ??
                                              '',
                                      bookDesc: recommendedBooklist[index]!
                                              .bookDesc ??
                                          '',
                                      bookshelfId: recommendedBooklist[index]!
                                              .bookshelfId ??
                                          '',
                                      bookPrice: recommendedBooklist[index]!
                                              .bookPrice ??
                                          '',
                                      bookTitle: recommendedBooklist[index]!
                                              .bookTitle ??
                                          '',
                                      bookAuthor: recommendedBooklist[index]!
                                              .bookAuthor ??
                                          '',
                                      bookNoOfPage: recommendedBooklist[index]!
                                              .bookNoOfPage ??
                                          '',
                                      booktypeName: recommendedBooklist[index]!
                                              .booktypeName ??
                                          '',
                                      publisherName: recommendedBooklist[index]!
                                              .publisherName ??
                                          '',
                                      bookIsbn: recommendedBooklist[index]!
                                              .bookIsbn ??
                                          '',
                                      bookcateId: '', // No data
                                      bookcateName: recommendedBooklist[index]!
                                              .bookcateName ??
                                          '',
                                      onlinetype: recommendedBooklist[index]!
                                              .onlinetype ??
                                          '',
                                      t2Id: '', // No data
                                      imgLink:
                                          recommendedBooklist[index]!.imgLink ??
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
                                        recommendedBooklist[index]!
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
                                              recommendedBooklist[index]!
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
                // child: Center(
                //     child: hasmore
                //         ? const CircularProgressIndicator()
                //         : const Text('')),
              );
            }
          }),
    );
  }
}
