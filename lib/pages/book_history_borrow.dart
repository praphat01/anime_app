import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../generated/locale_keys.g.dart';
import '../models/m_user/user_bookHistory.dart';
import '../pages/detailpage.dart';
import '../constants/colors.dart';

class bookHistoryBorrow extends StatefulWidget {
  const bookHistoryBorrow({
    Key? key,
  });

  @override
  State<bookHistoryBorrow> createState() => _bookHistoryBorrowState();
}

class _bookHistoryBorrowState extends State<bookHistoryBorrow> {
  final controller = ScrollController();
  int page = 1;
  List<Result?> dataBookHistory = [];
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
    final String? userLoginname = prefs.getString('userLoginname');
    final String? uniLink = prefs.getString('uniLink');
    final String? pathWebSite = prefs.getString('pathWebSite');
    const limited = 10;
    var getBookFaverites =
        "${uniLink}/booking_profile.php?uni_id=${uniId}&user=${userLoginname}";
    final uri = Uri.parse(getBookFaverites);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        dataBookHistory =
            userBookHistory.fromJson(decodedData).result as List<Result?>;
        setState(() {
          page++;

          if (dataBookHistory.length < limited) {
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
          LocaleKeys.book_history.tr(),
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
            itemCount: dataBookHistory.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 8,
              mainAxisExtent: 200,
            ),
            // itemCount: popularBooklist.length,
            itemBuilder: (BuildContext ctx, index) {
              if (index < dataBookHistory.length) {
                bookIdType =
                    dataBookHistory[index]!.bookId.toString().substring(1, 2);
                if (bookIdType == '9') {
                  imageUrl = dataBookHistory[index]!.imgLink.toString();
                  dataBookHistory[index]!.imgLink = imageUrl.replaceAll(
                      "http://www.2ebook.com/new", pathSite);
                }
                return Container(
                  //borderRadius: BorderRadius.circular(20),
                  child: (dataBookHistory[index]!.bookDesc != null &&
                          dataBookHistory[index]!.bookId != '0')
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => detailPage(
                                        bookId:
                                            dataBookHistory[index]!.bookId ??
                                                '',
                                        bookDesc:
                                            dataBookHistory[index]!.bookDesc ??
                                                '',
                                        bookshelfId: dataBookHistory[index]!
                                                .bookshelfId ??
                                            '',
                                        bookPrice:
                                            dataBookHistory[index]!.bookPrice ??
                                                '',
                                        bookTitle:
                                            dataBookHistory[index]!.bookTitle ??
                                                '',
                                        bookAuthor: dataBookHistory[index]!
                                                .bookAuthor ??
                                            '',
                                        bookNoOfPage: dataBookHistory[index]!
                                                .bookNoOfPage ??
                                            '',
                                        booktypeName: dataBookHistory[index]!
                                                .booktypeName ??
                                            '',
                                        publisherName: dataBookHistory[index]!
                                                .publisherName ??
                                            '',
                                        bookIsbn:
                                            dataBookHistory[index]!.bookIsbn ??
                                                '',
                                        bookcateId: '', // No data
                                        bookcateName: dataBookHistory[index]!
                                                .bookcateName ??
                                            '',
                                        onlinetype: dataBookHistory[index]!
                                                .onlinetype ??
                                            '',
                                        t2Id: '', // No data
                                        imgLink:
                                            dataBookHistory[index]!.imgLink ??
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
                                          dataBookHistory[index]!
                                              .imgLink
                                              .toString(),
                                          height: 150,
                                          width: 200,
                                          fit: BoxFit.fitWidth,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 160, left: 10),
                                          height: 30,
                                          width: 90,
                                          child: Stack(
                                            children: <Widget>[
                                              Center(
                                                  child: Text(
                                                dataBookHistory[index]!
                                                    .bookTitle
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
