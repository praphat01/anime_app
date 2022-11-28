// import 'package:anime_app/models/anime.dart';
import 'package:flutter/material.dart';
import '../models/m_allbook/new_book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/detailpage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class RecentsList extends StatefulWidget {
  const RecentsList({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentsList> createState() => _RecentsListState();
}

class _RecentsListState extends State<RecentsList> {
  List<Result?> dataBookAdd = [];
  var bookIdType;
  var pathSite;
  var imageUrl;
  var imageLocalFile;
  final controller = ScrollController();
  int page = 1;

  void get_uni() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? uniLink = prefs.getString('uniLink');
    final String? pathWebSite = prefs.getString('pathWebSite');

    var getUniApiUrl = "${uniLink}/new_book.php?uni_id=${uniId}&page=$page";

    final uri = Uri.parse(getUniApiUrl);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        dataBookAdd = [
          ...dataBookAdd,
          ...bookadded.fromJson(decodedData).result as List<Result?>
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

  void initState() {
    // TODO: implement initState
    super.initState();
    get_uni();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        get_uni();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.builder(
            controller: controller,
            itemCount: dataBookAdd.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, top: 5),
            itemBuilder: (BuildContext context, int index) {
              bookIdType =
                  dataBookAdd[index]!.bookId.toString().substring(1, 2);
              if (bookIdType == '9') {
                imageUrl = dataBookAdd[index]!.imgLink.toString();
                dataBookAdd[index]!.imgLink =
                    imageUrl.replaceAll("http://www.2ebook.com/new", pathSite);
              }
              return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => detailPage(
                                  bookId: dataBookAdd[index]!.bookId ?? '',
                                  bookDesc: dataBookAdd[index]!.bookDesc ?? '',
                                  bookshelfId:
                                      dataBookAdd[index]!.bookshelfId ?? '',
                                  bookPrice:
                                      dataBookAdd[index]!.bookPrice ?? '',
                                  bookTitle:
                                      dataBookAdd[index]!.bookTitle ?? '',
                                  bookAuthor:
                                      dataBookAdd[index]!.bookAuthor ?? '',
                                  bookNoOfPage:
                                      dataBookAdd[index]!.bookNoOfPage ?? '',
                                  booktypeName:
                                      dataBookAdd[index]!.booktypeName ?? '',
                                  publisherName:
                                      dataBookAdd[index]!.publisherName ?? '',
                                  bookIsbn: dataBookAdd[index]!.bookIsbn ?? '',
                                  bookcateId:
                                      dataBookAdd[index]!.bookcateId ?? '',
                                  bookcateName:
                                      dataBookAdd[index]!.bookcateName ?? '',
                                  onlinetype:
                                      dataBookAdd[index]!.onlinetype ?? '',
                                  t2Id: dataBookAdd[index]!.t2Id ?? '',
                                  imgLink: dataBookAdd[index]!.imgLink ?? '',
                                )),
                      );
                    },
                    child: SizedBox(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth * .375,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              dataBookAdd[index]!.imgLink.toString(),
                              height: 300.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(dataBookAdd[index]!.bookTitle.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
