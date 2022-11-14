import '../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/m_allbook/book_recommended.dart';
import '../pages/detailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListTrends extends StatefulWidget {
  const ListTrends({
    Key? key,
  }) : super(key: key);

  @override
  State<ListTrends> createState() => _ListTrendsState();
}

class _ListTrendsState extends State<ListTrends> {
  List<Result?> dataBookListTrends = [];
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

    var getUniApiUrl =
        "${uniLink}/book_recommended.php?uni_id=${uniId}&page=$page";
    final uri = Uri.parse(getUniApiUrl);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        dataBookListTrends = [
          ...dataBookListTrends,
          ...book_Recommended.fromJson(decodedData).result as List<Result?>
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
    return Expanded(
      child: LayoutBuilder(builder: (_, constraints) {
        return ListView.builder(
            controller: controller,
            itemCount: dataBookListTrends.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 10, left: 20),
            itemBuilder: (BuildContext context, int index) {
              bookIdType =
                  dataBookListTrends[index]!.bookId.toString().substring(1, 2);
              if (bookIdType == '9') {
                imageUrl = dataBookListTrends[index]!.imgLink.toString();
                dataBookListTrends[index]!.imgLink =
                    imageUrl.replaceAll("http://www.2ebook.com/new", pathSite);
              }
              final style = Theme.of(context)
                  .textTheme
                  .button
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.w600);
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => detailPage(
                                bookId: dataBookListTrends[index]!.bookId ?? '',
                                bookDesc:
                                    dataBookListTrends[index]!.bookDesc ?? '',
                                bookshelfId:
                                    dataBookListTrends[index]!.bookshelfId ??
                                        '',
                                bookPrice:
                                    dataBookListTrends[index]!.bookPrice ?? '',
                                bookTitle:
                                    dataBookListTrends[index]!.bookTitle ?? '',
                                bookAuthor:
                                    dataBookListTrends[index]!.bookAuthor ?? '',
                                bookNoOfPage:
                                    dataBookListTrends[index]!.bookNoOfPage ??
                                        '',
                                booktypeName:
                                    dataBookListTrends[index]!.booktypeName ??
                                        '',
                                publisherName:
                                    dataBookListTrends[index]!.publisherName ??
                                        '',
                                bookIsbn:
                                    dataBookListTrends[index]!.bookIsbn ?? '',
                                bookcateId:
                                    dataBookListTrends[index]!.bookcateId ?? '',
                                bookcateName:
                                    dataBookListTrends[index]!.bookcateName ??
                                        '',
                                onlinetype:
                                    dataBookListTrends[index]!.onlinetype ?? '',
                                t2Id: dataBookListTrends[index]!.t2Id ?? '',
                                imgLink:
                                    dataBookListTrends[index]!.imgLink ?? '',
                              )),
                    );
                  },
                  child: SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth * .375,
                    child: Column(children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            dataBookListTrends[index]!.imgLink.toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => const detailPage()),
                      //     );
                      //   },
                      //   child: const Text('Go back!'),
                      // ),
                      const SizedBox(height: 15),
                      Text(dataBookListTrends[index]!.bookTitle.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     // SvgPicture.asset('assets/icons/home.svg'),
                      //     const SizedBox(width: 5),
                      //     Text(
                      //       'Rating: ${anime.score}',
                      //       style: Theme.of(context).textTheme.button?.copyWith(
                      //           color: Colors.black, fontWeight: FontWeight.w600),
                      //     ),
                      //     const SizedBox(width: 7.5),
                      //     Text(
                      //       '# ${anime.number}',
                      //       style: style?.copyWith(color: AnimeUI.cyan),
                      //     ),
                      //   ],
                      // )
                    ]),
                  ),
                ),
              );
            });
      }),
    );
  }
}
