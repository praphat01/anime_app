import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/m_user/user_bookFaverite.dart';
import '../pages/detailpage.dart';
import '../constants/colors.dart';

class book_faverites extends StatefulWidget {
  const book_faverites({
    Key? key,
  });

  @override
  State<book_faverites> createState() => _book_faveritesState();
}

class _book_faveritesState extends State<book_faverites> {
  final controller = ScrollController();
  int page = 1;
  List<Result?> dataBookFaverites = [];
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
        "${uniLink}/get_fav.php?uni_id=${uniId}&user=${userLoginname}";
    final uri = Uri.parse(getBookFaverites);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        dataBookFaverites =
            userBookFavorite.fromJson(decodedData).result as List<Result?>;
        setState(() {
          page++;

          if (dataBookFaverites.length < limited) {
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
          'หนังสือเล่มโปรด',
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
            itemCount: dataBookFaverites.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 8,
              mainAxisExtent: 200,
            ),
            // itemCount: popularBooklist.length,
            itemBuilder: (BuildContext ctx, index) {
              if (index < dataBookFaverites.length) {
                bookIdType =
                    dataBookFaverites[index]!.bookId.toString().substring(1, 2);
                if (bookIdType == '9') {
                  imageUrl = dataBookFaverites[index]!.imgLink.toString();
                  dataBookFaverites[index]!.imgLink = imageUrl.replaceAll(
                      "http://www.2ebook.com/new", pathSite);
                }

                return Container(
                  //borderRadius: BorderRadius.circular(20),
                  child: (dataBookFaverites[index]!.bookDesc != null &&
                          dataBookFaverites[index]!.bookId != '0')
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => detailPage(
                                        bookId:
                                            dataBookFaverites[index]!.bookId ??
                                                '',
                                        bookDesc: dataBookFaverites[index]!
                                                .bookDesc ??
                                            '',
                                        bookshelfId: dataBookFaverites[index]!
                                                .bookshelfId ??
                                            '',
                                        bookPrice: dataBookFaverites[index]!
                                                .bookPrice ??
                                            '',
                                        bookTitle: dataBookFaverites[index]!
                                                .bookTitle ??
                                            '',
                                        bookAuthor: dataBookFaverites[index]!
                                                .bookAuthor ??
                                            '',
                                        bookNoOfPage: dataBookFaverites[index]!
                                                .bookNoOfPage ??
                                            '',
                                        booktypeName: dataBookFaverites[index]!
                                                .booktypeName ??
                                            '',
                                        publisherName: dataBookFaverites[index]!
                                                .publisherName ??
                                            '',
                                        bookIsbn: dataBookFaverites[index]!
                                                .bookIsbn ??
                                            '',
                                        bookcateId: '', // No data
                                        bookcateName: dataBookFaverites[index]!
                                                .bookcateName ??
                                            '',
                                        onlinetype: dataBookFaverites[index]!
                                                .onlinetype ??
                                            '',
                                        t2Id: '', // No data
                                        imgLink:
                                            dataBookFaverites[index]!.imgLink ??
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
                                          dataBookFaverites[index]!
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
                                                dataBookFaverites[index]!
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
