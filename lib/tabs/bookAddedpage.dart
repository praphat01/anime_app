import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/m_allbook/new_book.dart';
import '../pages/detailpage.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class bookAdded extends StatefulWidget {
  const bookAdded({Key? key}) : super(key: key);

  @override
  State<bookAdded> createState() => _bookAddedState();
}

class _bookAddedState extends State<bookAdded> {
  final controller = ScrollController();
  int page = 1;
  List<Result?> newBooklist = [];
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

    const limited = 10;
    var getNewBook = "${uniLink}/new_book.php?uni_id=${uniId}&page=$page";
    final uri = Uri.parse(getNewBook);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        newBooklist = [
          ...newBooklist,
          ...bookadded.fromJson(decodedData).result as List<Result?>
        ];
        setState(() {
          page++;

          if (newBooklist.length < limited) {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          shrinkWrap: true,
          controller: controller,
          itemCount: newBooklist.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 8,
            mainAxisExtent: 200,
          ),
          // itemCount: popularBooklist.length,
          itemBuilder: (BuildContext ctx, index) {
            if (index < newBooklist.length) {
              bookIdType =
                  newBooklist[index]!.bookId.toString().substring(1, 2);
              if (bookIdType == '9') {
                imageUrl = newBooklist[index]!.imgLink.toString();
                newBooklist[index]!.imgLink =
                    imageUrl.replaceAll("http://www.2ebook.com/new", pathSite);
              }
              return Container(
                //borderRadius: BorderRadius.circular(20),
                child: (newBooklist[index]!.bookDesc != null &&
                        newBooklist[index]!.bookId != '0')
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => detailPage(
                                      bookId: newBooklist[index]!.bookId ?? '',
                                      bookDesc:
                                          newBooklist[index]!.bookDesc ?? '',
                                      bookshelfId:
                                          newBooklist[index]!.bookshelfId ?? '',
                                      bookPrice:
                                          newBooklist[index]!.bookPrice ?? '',
                                      bookTitle:
                                          newBooklist[index]!.bookTitle ?? '',
                                      bookAuthor:
                                          newBooklist[index]!.bookAuthor ?? '',
                                      bookNoOfPage:
                                          newBooklist[index]!.bookNoOfPage ??
                                              '',
                                      booktypeName:
                                          newBooklist[index]!.booktypeName ??
                                              '',
                                      publisherName:
                                          newBooklist[index]!.publisherName ??
                                              '',
                                      bookIsbn:
                                          newBooklist[index]!.bookIsbn ?? '',
                                      bookcateId: '', // No data
                                      bookcateName:
                                          newBooklist[index]!.bookcateName ??
                                              '',
                                      onlinetype:
                                          newBooklist[index]!.onlinetype ?? '',
                                      t2Id: '', // No data
                                      imgLink:
                                          newBooklist[index]!.imgLink ?? '',
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
                                        newBooklist[index]!.imgLink.toString(),
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
                                              newBooklist[index]!
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
}
