// ignore_for_file: avoid_print
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../generated/locale_keys.g.dart';
import '../models/m_allbook/user_bookshelf.dart';
import '../pages/detailpage.dart';
import '../constants/colors.dart';
import '../widgets/leftmenu.dart';
import '../pages/search/search.dart';
import '../pages/pdfviewer/flutter_pdfviewer.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:isolate';
import 'dart:ui';
// import '../widgets/openPdf.dart';
import 'dart:async';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../pages/mainpage.dart';
import '../models/m_detail/m_rateingStar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../database/database_helper.dart';
import 'package:flutter/foundation.dart';
// import '../pages/pdfviewer/api/pdf_api.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import '../pages/videoPlayer/vdoPlayer.dart';

class bookshelf extends StatefulWidget {
  // static late DownloadCallback download;

  const bookshelf({Key? key}) : super(key: key);

  @override
  State<bookshelf> createState() => _bookshelfState();
}

class _bookshelfState extends State<bookshelf> {
  final ReceivePort _port = ReceivePort();
  final controller = ScrollController();
  int page = 1;
  List<InsertKey?> userBookShelflist = [];
  List<String> databook = [];
  List<Map<String, dynamic>> myData = [];
  bool hasmore = true;
  String statusFile = '';
  String _localPath = '';
  bool hasBook = false;
  var bookIdType;
  var pathSite;
  var imageUrl;
  var pdfUrl;
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

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  void returnBook(
      {required bookshelfId, required DB_id, required pdfLink}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? userLoginname = prefs.getString('userLoginname');
    final String? uniLink = prefs.getString('uniLink');

    var getCheckFav =
        "${uniLink}/checkin.php?bookshelf_id=${bookshelfId}&user=${userLoginname}&uni_id=${uniId}";
    final uri = Uri.parse(getCheckFav);
    http.get(uri).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        AlertDialogReturnBook(context);
        deleteBookFromStorage(DB_id, pdfLink);
      }
    });
  }

  void deleteItem(int id) async {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully deleted!'), backgroundColor: Colors.green));
    _refreshData();
  }

  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    setState(() {
      myData = data;
    });
  }

  void deleteBookFromStorage(DB_id, pdfLink) async {
    List<Map> data = await DatabaseHelper.getIDWithBookId(DB_id);
    final existingData =
        data.firstWhere((element) => element['book_id'] == DB_id);
    if (existingData['id'] != null) {
      await DatabaseHelper.deleteItem(existingData['id']);

      File file = new File(pdfLink);
      String filename = path.basename(file.path);
      var appDocDir = await getExternalStorageDirectory();
      String nameFile = "/${filename}";
      String pathFile = appDocDir!.path + nameFile;
      final fileDelete = File(pathFile);
      try {
        if (await fileDelete.exists()) {
          await fileDelete.delete();
          print('Alread delete');
        }
      } catch (e) {
        // Error in getting access to the file.
      }
    }
  }

  AlertDialogReturnBook(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('SUCCESS'),
        content: const Text('คืนหนังสือ สำเร็จแล้ว!'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainPage(selectedPage: 1)),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? checkTypeOfFile(bookUrl) {
    File file = new File(bookUrl);
    String filename = path.basename(file.path);
    String? typeOfFile = lookupMimeType(filename);
    print('Arm test type ====> $typeOfFile');
    return typeOfFile;
  }

  Future fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? userLoginname = prefs.getString('userLoginname');
    final String? uniLink = prefs.getString('uniLink');
    final String? pathWebSite = prefs.getString('pathWebSite');
    const noBook = 0;
    const limited = 10;
    // _localPath = (await _findLocalPath())!;
    var getNewBook =
        "${uniLink}/server_update.php?user=${userLoginname}&uni_id=${uniId}";
    print('server update ==> $getNewBook');
    final uri = Uri.parse(getNewBook);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        if (decodedData["insert_key"] != Null) {
          userBookShelflist = [
            ...userBookShelflist,
            ...userBookshelf.fromJson(decodedData).insertKey as List<InsertKey?>
          ];
        }

        setState(() {
          page++;
          pathSite = pathWebSite;
          // _localPath;
        });
      } else {}
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  void download({required pdfLink}) async {
    // Navigator.of(context).pop();
    String pdfLinkNew =
        pdfLink.replaceAll("ebook_tab", "ebook_wm"); // Test file unlock
    File file = new File(pdfLink);
    String filename = path.basename(file.path);
    print(filename);
    print('##14nov pdfLink ===> $pdfLink');

    try {
      await [
        Permission.storage,
      ].request();

      var appDocDir = await getExternalStorageDirectory();
      String nameFile = "/${filename}";
      String savePath = appDocDir!.path + nameFile;

      var response = await Dio()
          .download(pdfLinkNew, savePath); // USE pdfLink NOT  pdfLinkNew
      await ImageGallerySaver.saveFile(appDocDir.path, name: nameFile)
          .then((value) {
        print('Save file Success $savePath');
        Fluttertoast.showToast(
          msg: 'Download Book finished.',
          toastLength: Toast.LENGTH_LONG,
        );
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkfileBeforeReadPdf({required fileBook}) async {
    var appDocDir = await getExternalStorageDirectory();
    File file = new File(fileBook);
    String filename = path.basename(file.path);
    String nameFile = "/${filename}";
    String savePath = appDocDir!.path + nameFile;

    final checkStatus = await File(savePath).exists();
    print('check file exists is ==> $checkStatus');
    return checkStatus;
  }

  @override
  Widget build(BuildContext context) {
    if (userBookShelflist.length != 0) {
      hasBook = true;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.menu_Bookshelf.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AnimeUI.cyan,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const searchPage()),
              );
            },
          ),
        ],
      ),
      drawer: const PublicDrawer(),
      body: hasBook
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  controller: controller,
                  itemCount: userBookShelflist.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 200,
                  ),

                  // itemCount: popularBooklist.length,
                  itemBuilder: (BuildContext ctx, index) {
                    if (index < userBookShelflist.length) {
                      bookIdType = userBookShelflist[index]!
                          .bookId
                          .toString()
                          .substring(1, 2);
                      if (bookIdType == '9') {
                        // Re url image
                        imageUrl = userBookShelflist[index]!.imgLink.toString();
                        userBookShelflist[index]!.imgLink = imageUrl.replaceAll(
                            "http://www.2ebook.com/new", pathSite);
                        // userBookShelflist[index]!.imgLink = imageUrl.replaceAll(
                        //     "http://2ebook.com/new", pathSite);

                        // Re url pdf
                        pdfUrl = userBookShelflist[index]!.pdfLink.toString();
                        userBookShelflist[index]!.pdfLink = pdfUrl.replaceAll(
                            "http://www.2ebook.com/new", pathSite);
                        userBookShelflist[index]!.pdfLink = pdfUrl.replaceAll(
                            "http://2ebook.com/new", pathSite);
                        // print(
                        //     '##zzz ===> ${userBookShelflist[index]!.pdfLink}');
                      }
                      return Container(
                        //borderRadius: BorderRadius.circular(20),
                        child: (userBookShelflist[index]!.bookDesc != null &&
                                userBookShelflist[index]!.bookId != '0')
                            ? InkWell(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    scrollable: true,
                                    content: Column(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            download(
                                                pdfLink:
                                                    userBookShelflist[index]!
                                                        .pdfLink);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: AnimeUI
                                                .cyan, // Background color
                                          ),
                                          icon: const Icon(
                                            Icons.download,
                                            size: 24.0,
                                          ),
                                          label: Text(
                                            LocaleKeys.download.tr(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),

                                        // if ( checkfileBeforeReadPdf(
                                        //         fileBook:
                                        //             userBookShelflist[index]!
                                        //                     .pdfLink ??
                                        //                 '')) {

                                        //                 }else{

                                        //                 }

                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            if (await checkfileBeforeReadPdf(
                                                fileBook:
                                                    userBookShelflist[index]!
                                                            .pdfLink ??
                                                        '')) {
                                              // Check file book in storage
                                              if (checkTypeOfFile(
                                                      userBookShelflist[index]!
                                                          .pdfLink) ==
                                                  'application/pdf') {
                                                // check type of book is PDF
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ebookReader(
                                                        bookTitle:
                                                            userBookShelflist[
                                                                        index]!
                                                                    .bookTitle ??
                                                                '',
                                                        fileBook:
                                                            userBookShelflist[
                                                                        index]!
                                                                    .pdfLink ??
                                                                '',
                                                      ),
                                                    ));
                                              } else if (checkTypeOfFile(
                                                          userBookShelflist[
                                                                  index]!
                                                              .pdfLink) ==
                                                      'video/mp4' ||
                                                  checkTypeOfFile(
                                                          userBookShelflist[
                                                                  index]!
                                                              .pdfLink) ==
                                                      'audio/mpeg') {
                                                // check type of book is Video
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          vdoPlayer(
                                                        bookTitle:
                                                            userBookShelflist[
                                                                        index]!
                                                                    .bookTitle ??
                                                                '',
                                                        fileBook:
                                                            userBookShelflist[
                                                                        index]!
                                                                    .pdfLink ??
                                                                '',
                                                      ),
                                                    ));
                                              }
                                            } else {}
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AnimeUI
                                                .cyan, // Background color
                                          ),
                                          icon: const Icon(
                                            Icons.menu_book,
                                            size: 24.0,
                                          ),
                                          label: Text(
                                            '${LocaleKeys.read.tr()}  ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    detailPage(
                                                  bookId:
                                                      userBookShelflist[index]!
                                                              .bookId ??
                                                          '',
                                                  bookDesc:
                                                      userBookShelflist[index]!
                                                              .bookDesc ??
                                                          '',
                                                  bookshelfId:
                                                      userBookShelflist[index]!
                                                              .bookshelfId ??
                                                          '',
                                                  bookPrice:
                                                      userBookShelflist[index]!
                                                              .bookPrice ??
                                                          '',
                                                  bookTitle:
                                                      userBookShelflist[index]!
                                                              .bookTitle ??
                                                          '',
                                                  bookAuthor:
                                                      userBookShelflist[index]!
                                                              .bookAuthor ??
                                                          '',
                                                  bookNoOfPage:
                                                      userBookShelflist[index]!
                                                              .bookNoOfPage ??
                                                          '',
                                                  booktypeName:
                                                      userBookShelflist[index]!
                                                              .booktypeName ??
                                                          '',
                                                  publisherName:
                                                      userBookShelflist[index]!
                                                              .publisherName ??
                                                          '',
                                                  bookIsbn:
                                                      userBookShelflist[index]!
                                                              .bookIsbn ??
                                                          '',
                                                  bookcateId: '', // No data
                                                  bookcateName:
                                                      userBookShelflist[index]!
                                                              .bookcateName ??
                                                          '',
                                                  onlinetype: '', // No data
                                                  t2Id: '', // No data
                                                  imgLink:
                                                      userBookShelflist[index]!
                                                              .imgLink ??
                                                          '',
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: AnimeUI
                                                .cyan, // Background color
                                          ),
                                          icon: const Icon(
                                            Icons.feed_rounded,
                                            size: 24.0,
                                          ),
                                          label: Text(
                                            '${LocaleKeys.detailsData.tr()} ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            returnBook(
                                                bookshelfId:
                                                    userBookShelflist[index]!
                                                            .bookshelfId ??
                                                        '',
                                                DB_id: userBookShelflist[index]!
                                                        .bookId ??
                                                    '',
                                                pdfLink:
                                                    userBookShelflist[index]!
                                                            .pdfLink ??
                                                        '');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: AnimeUI
                                                .cyan, // Background color
                                          ),
                                          icon: const Icon(
                                            Icons.keyboard_return_outlined,
                                            size: 24.0,
                                          ),
                                          label: Text(
                                            '${LocaleKeys.returnBook.tr()}    ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Card(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        elevation: 10.0,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Image.network(
                                                userBookShelflist[index]!
                                                    .imgLink
                                                    .toString(),
                                                height: 150,
                                                width: 200,
                                                fit: BoxFit.fitWidth,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 160, left: 20),
                                                height: 30,
                                                width: 90,
                                                child: Stack(
                                                  children: <Widget>[
                                                    Center(
                                                        child: Text(
                                                      userBookShelflist[index]!
                                                          .bookDesc
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
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
                                ),
                              )
                            : Image.asset('assets/images/logo_2ebook.png'),
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(),
                        // child: hasmore
                        //     ? const CircularProgressIndicator()
                        //     : const Text('')),
                      );
                    }
                  }),
            )
          : Container(
              child: Center(
                child: Text(
                  LocaleKeys.noBook.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}

showDataAlert(context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {},
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("My title"),
    content: const Text("This is my message."),
    actions: [
      okButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
