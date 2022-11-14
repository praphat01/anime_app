// import '../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/m_allbook/bookPopular.dart';
import '../pages/detailpage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class popular extends StatefulWidget {
  const popular({Key? key}) : super(key: key);

  @override
  State<popular> createState() => _popularState();
}

class _popularState extends State<popular> {
  List<Result?> dataBookPopular = [];
  var bookIdType;
  var pathSite;
  var imageUrl;
  var imageLocalFile;
  final controller = ScrollController();
  int page = 1;

  void get_bookPopular() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? uniLink = prefs.getString('uniLink');
    final String? pathWebSite = prefs.getString('pathWebSite');
    var getBookPopularUrl =
        "${uniLink}/book_popular.php?uni_id=${uniId}&page=$page";
    final uri = Uri.parse(getBookPopularUrl);
    http.get(uri).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        dataBookPopular = [
          ...dataBookPopular,
          ...bookPopular.fromJson(decodedData).result as List<Result?>
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
    get_bookPopular();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        get_bookPopular();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 250,
        child: ScrollSnapList(
          itemBuilder: _buildListItem,
          listController: controller,
          itemCount: dataBookPopular.length,
          itemSize: 150,
          onItemFocus: (index) {},
          dynamicItemSize: true,
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    bookIdType = dataBookPopular[index]!.bookId.toString().substring(1, 2);
    if (bookIdType == '9') {
      imageUrl = dataBookPopular[index]!.imgLink.toString();
      dataBookPopular[index]!.imgLink =
          imageUrl.replaceAll("http://www.2ebook.com/new", pathSite);
    }
    // Product product = productList[index];
    return SizedBox(
      width: 150,
      height: 350,
      child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 12,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => detailPage(
                        bookId: dataBookPopular[index]!.bookId ?? '',
                        bookDesc: dataBookPopular[index]!.bookDesc ?? '',
                        bookshelfId: dataBookPopular[index]!.bookshelfId ?? '',
                        bookPrice: dataBookPopular[index]!.bookPrice ?? '',
                        bookTitle: dataBookPopular[index]!.bookTitle ?? '',
                        bookAuthor: dataBookPopular[index]!.bookAuthor ?? '',
                        bookNoOfPage:
                            dataBookPopular[index]!.bookNoOfPage ?? '',
                        booktypeName:
                            dataBookPopular[index]!.booktypeName ?? '',
                        publisherName:
                            dataBookPopular[index]!.publisherName ?? '',
                        bookIsbn: dataBookPopular[index]!.bookIsbn ?? '',
                        bookcateId: dataBookPopular[index]!.bookcateId ?? '',
                        bookcateName:
                            dataBookPopular[index]!.bookcateName ?? '',
                        onlinetype: dataBookPopular[index]!.onlinetype ?? '',
                        t2Id: dataBookPopular[index]!.t2Id ?? '',
                        imgLink: dataBookPopular[index]!.imgLink ?? '',
                      )),
            );
          },
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    dataBookPopular[index]!.imgLink.toString(),
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataBookPopular[index]!.bookTitle.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
