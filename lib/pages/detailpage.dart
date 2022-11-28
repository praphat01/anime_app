import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import '../generated/locale_keys.g.dart';
import '../models/m_detail/m_rateingStar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/m_detail/check_fav.dart';
import '../../database/database_helper.dart';

class detailPage extends StatefulWidget {
  final String bookId;
  final String bookDesc;
  final String bookshelfId;
  final String bookPrice;
  final String bookAuthor;
  final String bookTitle;
  final String bookNoOfPage;
  final String publisherName;
  final String booktypeName;
  final String bookcateId;
  final String bookIsbn;
  final String bookcateName;
  final String onlinetype;
  final String t2Id;
  final String imgLink;

  const detailPage(
      {Key? key,
      required this.bookId,
      required this.bookDesc,
      required this.bookshelfId,
      required this.bookPrice,
      required this.bookTitle,
      required this.bookAuthor,
      required this.bookNoOfPage,
      required this.booktypeName,
      required this.publisherName,
      required this.bookIsbn,
      required this.bookcateId,
      required this.bookcateName,
      required this.onlinetype,
      required this.t2Id,
      required this.imgLink});

  @override
  State<detailPage> createState() => _detailPageState(
        bookId: bookId,
        bookDesc: bookDesc,
        bookshelfId: bookshelfId,
        bookPrice: bookPrice,
        bookTitle: bookTitle,
        bookAuthor: bookAuthor,
        bookNoOfPage: bookNoOfPage,
        booktypeName: booktypeName,
        publisherName: publisherName,
        bookIsbn: bookIsbn,
        bookcateId: bookcateId,
        bookcateName: bookcateName,
        onlinetype: onlinetype,
        t2Id: t2Id,
        imgLink: imgLink,
      );
}

class _detailPageState extends State<detailPage> {
  String bookId;
  String bookDesc;
  String bookshelfId;
  String bookPrice;
  String bookTitle;
  String bookAuthor;
  String bookNoOfPage;
  String booktypeName;
  String publisherName;
  String bookIsbn;
  String bookcateId;
  String bookcateName;
  String t2Id;
  String imgLink;
  String onlinetype;

  _detailPageState({
    required this.bookId,
    required this.bookDesc,
    required this.bookshelfId,
    required this.bookPrice,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookNoOfPage,
    required this.booktypeName,
    required this.publisherName,
    required this.bookIsbn,
    required this.bookcateId,
    required this.bookcateName,
    required this.t2Id,
    required this.imgLink,
    required this.onlinetype,
  });

  final ReceivePort _port = ReceivePort();
  Future<Directory?>? externalStorageDirPath;
  List<rating_star?> dataRateing = [];
  int gottenStar = 0;
  late bool statusFav = false;
  late bool borrowStatus = true;
  var bookIdType;
  var pathSite;
  var imageUrl;
  var imageLocalFile;

  void getBookRating() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? userLoginname = prefs.getString('userLoginname');
    final String? uniLink = prefs.getString('uniLink');
    // bool statusFav = true;

    var getCheckFav =
        "${uniLink}/get_review_count.php?book_id=${widget.bookId}&uni_id=${uniId}";
    final uri = Uri.parse(getCheckFav);
    http.get(uri).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        print(bookId);
        setState(() {
          var ratingStar = decodedData['result'];
          gottenStar = ratingStar;
        });
      } else {}
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }

  void getChkFav() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? userLoginname = prefs.getString('userLoginname');
    final String? uniLink = prefs.getString('uniLink');
    // bool statusFav = false;
    var getPublisher =
        "${uniLink}/check_fav.php?user=${userLoginname}&uni_id=${uniId}&bookshelf_id=${widget.bookshelfId}";
    final uri = Uri.parse(getPublisher);
    http.get(uri).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        setState(() {
          if (decodedData['status'] == 'false') {
            statusFav = false;
          } else {
            statusFav = true;
          }
        });
      }
    });
  }

  void clickFavBook({required book}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? userLoginname = prefs.getString('userLoginname');
    final String? uniLink = prefs.getString('uniLink');
    bool statusFavBoo = false;

    if (book == 'favBook') {
      Response response = await post(Uri.parse('${uniLink}/add_fav.php'),
          body: {
            'user': userLoginname,
            'uni_id': uniId,
            'bookshelf_id': widget.bookshelfId
          });

      setState(() {
        statusFav = true;
      });
    } else if (book == 'unFavBook') {
      Response response = await post(Uri.parse('${uniLink}/del_fav.php'),
          body: {
            'user': userLoginname,
            'uni_id': uniId,
            'bookshelf_id': widget.bookshelfId
          });

      setState(() {
        statusFav = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChkFav();
    getBookRating();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    // FlutterDownloader.registerCallback(downloadCallback);
  }

  // borrowStatus = false;

  @override
  void dispose() {
    // IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  void borrowBook() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? userLoginname = prefs.getString('userLoginname');
    final String? uniLink = prefs.getString('uniLink');
    var status = false;
    var getBorrow =
        "${uniLink}/borrow.php?bookshelf_id=${widget.bookshelfId}&user=${userLoginname}&book_id=${widget.bookId}&uni_id=${uniId}&os=4";
    print('Arm test == > $getBorrow');
    final uri = Uri.parse(getBorrow);

    http.get(uri).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        if (decodedData['status'] == 'false') {
          setState(() {
            borrowStatus = false;
          });
          if (decodedData['result'] == 'borrowlimit') {
            AlertDialogBorrowlimit(context);
          }
        } else {
          AlertDialogSuccess(context);
          await addItem();
          setState(() {
            borrowStatus = true;
          });
        }
      }
    });
  }

  Future<void> addItem() async {
    await DatabaseHelper.createItem(widget.bookId, widget.bookTitle);
    _refreshData();
  }

  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    print(data);
  }

  AlertDialogBorrowlimit(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(LocaleKeys.borrowBook.tr()),
        content: Text(LocaleKeys.alertBookLimit.tr()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, LocaleKeys.ok.tr()),
            child: Text(LocaleKeys.ok.tr()),
          ),
        ],
      ),
    );
  }

  AlertDialogSuccess(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(LocaleKeys.success.tr()),
        content: Text(LocaleKeys.alertBorrowSuccess.tr()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text(LocaleKeys.ok.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(imgLink), fit: BoxFit.cover),
                ),
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: new Container(
                    decoration:
                        new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.8),
                          spreadRadius: 5,
                          blurRadius: 4,
                          offset: Offset(4, 8), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Image.network(
                      imgLink,
                      height: 220,
                      width: 150,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 280,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                width: MediaQuery.of(context).size.width,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(15),
                  children: <Widget>[
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 320),
                                child: Container(
                                  child: Text(
                                    bookTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Wrap(
                                children: List.generate(
                                  5,
                                  (index) {
                                    return Icon(
                                      Icons.star,
                                      color: index < gottenStar
                                          ? Colors.yellow
                                          : Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '(${gottenStar}.0)',
                                style: TextStyle(
                                    color: Colors.purple.withOpacity(0.6)),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (statusFav == true)
                                  ? OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          statusFav = false;
                                        });
                                        clickFavBook(book: 'unFavBook');
                                      },
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 25.0,
                                      ),
                                    )
                                  : OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          statusFav = true;
                                        });
                                        clickFavBook(book: 'favBook');
                                      },
                                      child: const Icon(
                                        Icons.favorite_border,
                                        color: Colors.red,
                                        size: 25.0,
                                      ),
                                    ),
                              OutlinedButton(
                                onPressed: () {
                                  debugPrint('Received click');
                                },
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.blue,
                                    onSurface: Colors.red,
                                  ),
                                  onPressed: () {
                                    // _showDialog();
                                    // borrowStatus ? borrowBook() : '';
                                    borrowBook();
                                  },
                                  child: Text(
                                    LocaleKeys.borrow.tr(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            LocaleKeys.bookDetails.tr(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${LocaleKeys.detailsData.tr()} : ",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            bookDesc, // รายละเอียดหนังสือ
                            style: const TextStyle(
                                fontSize: 15, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "${LocaleKeys.auther.tr()} : ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                bookAuthor, // ชื่อผู้แต่ง
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "${LocaleKeys.publisherData.tr()} : ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                publisherName, // ชื่อสำนักพิมพ์
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "${LocaleKeys.typeOfBook.tr()} : ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                booktypeName, // ชนิดหนังสือ
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "${LocaleKeys.bookCategory.tr()} : ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                bookcateName, // หมวดหมู่หนังสือ
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "${LocaleKeys.title.tr()} : ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "-",
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "${LocaleKeys.book_id.tr()} : ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                bookId, // รหัสหนังสือ
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "${LocaleKeys.ISBN_number.tr()} : ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                bookIsbn, // เลข ISBN
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "${LocaleKeys.pages.tr()} : ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                bookNoOfPage, // จำนวนหน้าหนังสือ
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "${LocaleKeys.bookAmount.tr()} : ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                onlinetype, // จำนวนหนังสือ
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // BottomNavBar(),
          ],
        ),
      ),
    );
  }
}
