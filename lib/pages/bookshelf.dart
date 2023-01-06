import 'package:anime_app/widgets/widget_circulat_percent.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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

import 'dart:async';

import '../pages/mainpage.dart';
import '../models/m_detail/m_rateingStar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../database/database_helper.dart';
import 'package:flutter/foundation.dart';

import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import '../pages/videoPlayer/vdoPlayer.dart';

import 'package:intl/intl.dart';

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
  bool load = true;
  bool hasBook = false;
  var bookIdType;
  var pathSite;
  var imageUrl;
  var pdfUrl;
  var imageLocalFile;
  var files;
  late List<FileSystemEntity> _folders;

  String? percent;

  bool displayProcessLoadPdf = false;
  double percentNumber = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkExpireBook();
    fetch();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen(
      (dynamic data) {
        String id = data[0];
        DownloadTaskStatus status = data[1];
        int progress = data[2];
        setState(() {});
      },
    );

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

  // void checkExpireBook() async {
  //   final directory = await getExternalStorageDirectory();
  //   final dir = directory!.path;
  //   String pdfDirectory = '$dir/';
  //   final myDir = new Directory(pdfDirectory);
  //   setState(() {
  //     _folders = myDir.listSync(recursive: true, followLinks: false);
  //   });
  //   for (var pathFileData in _folders) {
  //     // print('path file data is ==> $pathFileData');

  //     String filename = path.basename(pathFileData.toString());
  //     print('name file data is ==> $filename');
  //   }
  // }

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
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(selectedPage: 1)),
              );
            },
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
    // print('Arm test type ====> $typeOfFile');
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
    // print('server update ==> $getNewBook');
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

        load = false;

        setState(() {
          page++;
          pathSite = pathWebSite;
          // _localPath;
        });
      }
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }

  Widget circular(hasBook) {
    return Center(child: CircularProgressIndicator());
    // if (hasBook == true) {
    //   return Center(child: CircularProgressIndicator());
    // } else {
    //   return Container(
    //     child: Center(
    //       child: Text(
    //         LocaleKeys.noBook.tr(),
    //         style: const TextStyle(
    //           fontSize: 18,
    //           fontWeight: FontWeight.bold,
    //           color: Colors.grey,
    //         ),
    //         textAlign: TextAlign.center,
    //       ),
    //     ),
    //   );
    // }
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
    // String percent = '';
    // double percentNumber = 0.0;

    String pdfLinkNew =
        pdfLink.replaceAll("ebook_tab", "ebook_wm"); // Test file unlock
    File file = File(pdfLink);
    String filename = path.basename(file.path);
    // print(filename);
    // print('##14nov pdfLink ===> $pdfLink');

    await [
      Permission.storage,
    ].request();

    var appDocDir = await getExternalStorageDirectory();
    String nameFile = "/${filename}";
    String savePath = appDocDir!.path + nameFile;

    double second = 0.1;

    await Dio().download(pdfLinkNew, savePath,
        onReceiveProgress: (count, total) {
      // print((count / total * 100).toStringAsFixed(0) + "%");

      percent = (count / total * 100).toStringAsFixed(0) + "%";
      percentNumber = double.parse((count / total * 100).toStringAsFixed(0));

      displayProcessLoadPdf = true;

      setState(() {});

      // showDialog(
      //     barrierColor: Colors.black.withOpacity(0.01),
      //     context: context,
      //     builder: (context) {
      //       return WidgetCirculatPercentIndicator(percentNumber: percentNumber);
      //     });
    }).then((value) {
      displayProcessLoadPdf = false;
      setState(() {});
    });

    await ImageGallerySaver.saveFile(appDocDir.path, name: nameFile)
        .then((value) {
      Fluttertoast.showToast(
        msg: LocaleKeys.downloadFinished.tr(),
        toastLength: Toast.LENGTH_LONG,
      );
    });
    // Navigator.of(context, rootNavigator: true).pop(context);
  }

  Future<bool> checkfileBeforeReadPdf({required fileBook}) async {
    var appDocDir = await getExternalStorageDirectory();
    File file = new File(fileBook);
    String filename = path.basename(file.path);
    String nameFile = "/${filename}";
    String savePath = appDocDir!.path + nameFile;

    final checkStatus = await File(savePath).exists();
    // print('check file exists is ==> $checkStatus');
    return checkStatus;
  }

  @override
  Widget build(BuildContext context) {
    if (userBookShelflist.length == 0) {
      hasBook = false;
    } else {
      hasBook = true;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.menu_Bookshelf.tr(),
          style: const TextStyle(
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
      body: load
          ? circular(hasBook)
          : hasBook
              ? Stack(
                  children: [
                    contentMain(),
                    displayProcessLoadPdf
                        ? showProcessLoad()
                        : const SizedBox(),
                  ],
                )
              : Container(
                  child: Center(
                    child: Text(
                      LocaleKeys.noBook.tr(),
                      style: const TextStyle(
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

  Widget showProcessLoad() {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.25)),
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      child: WidgetCirculatPercentIndicator(percentNumber: percentNumber),
    );
  }

  Widget endTime(endTime) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(endTime);
    var outputFormat = DateFormat('dd/MM/yyyy');

    return Positioned(
      bottom: 42,
      right: 3,
      child: Text(
        'EXP. ${outputFormat.format(inputDate)}',
        style: TextStyle(
          fontSize: 13,
          backgroundColor: Color.fromARGB(153, 0, 0, 0),
          color: Colors.white,
        ),
      ),
    );
  }

  Padding contentMain() {
    return Padding(
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
              bookIdType =
                  userBookShelflist[index]!.bookId.toString().substring(1, 2);
              if (bookIdType == '9') {
                // Re url image
                imageUrl = userBookShelflist[index]!.imgLink.toString();
                userBookShelflist[index]!.imgLink =
                    imageUrl.replaceAll("http://www.2ebook.com/new", pathSite);
                // userBookShelflist[index]!.imgLink = imageUrl.replaceAll(
                //     "http://2ebook.com/new", pathSite);

                // Re url pdf
                pdfUrl = userBookShelflist[index]!.pdfLink.toString();
                userBookShelflist[index]!.pdfLink =
                    pdfUrl.replaceAll("http://www.2ebook.com/new", pathSite);
                userBookShelflist[index]!.pdfLink =
                    pdfUrl.replaceAll("http://2ebook.com/new", pathSite);
              }
              return Container(
                //borderRadius: BorderRadius.circular(20),
                child: (userBookShelflist[index]!.bookDesc != null &&
                        userBookShelflist[index]!.bookId != '0')
                    ? InkWell(
                        onTap: () async {
                          if ((await checkfileBeforeReadPdf(
                                  fileBook:
                                      userBookShelflist[index]!.pdfLink) ==
                              false)) {
                            bookshelfMenuDownload(
                                userBookShelflist[index]!.pdfLink,
                                userBookShelflist[index]!.bookTitle,
                                userBookShelflist[index]!.bookId,
                                userBookShelflist[index]!.bookDesc,
                                userBookShelflist[index]!.bookshelfId,
                                userBookShelflist[index]!.bookPrice,
                                userBookShelflist[index]!.bookAuthor,
                                userBookShelflist[index]!.bookNoOfPage,
                                userBookShelflist[index]!.booktypeName,
                                userBookShelflist[index]!.publisherName,
                                userBookShelflist[index]!.bookIsbn,
                                userBookShelflist[index]!.bookcateName,
                                userBookShelflist[index]!.imgLink);
                          } else {
                            bookshelfMenuRead(
                                userBookShelflist[index]!.pdfLink,
                                userBookShelflist[index]!.bookTitle,
                                userBookShelflist[index]!.bookId,
                                userBookShelflist[index]!.bookDesc,
                                userBookShelflist[index]!.bookshelfId,
                                userBookShelflist[index]!.bookPrice,
                                userBookShelflist[index]!.bookAuthor,
                                userBookShelflist[index]!.bookNoOfPage,
                                userBookShelflist[index]!.booktypeName,
                                userBookShelflist[index]!.publisherName,
                                userBookShelflist[index]!.bookIsbn,
                                userBookShelflist[index]!.bookcateName,
                                userBookShelflist[index]!.imgLink);
                          }
                        },
                        child: Column(
                          children: [
                            Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
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
                                    endTime(userBookShelflist[index]!
                                        .endTime
                                        .toString()),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 160, left: 20),
                                      height: 30,
                                      width: 120,
                                      child: Stack(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              userBookShelflist[index]!
                                                  .bookDesc
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Future AlertNoBook() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(LocaleKeys.readFailed.tr()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(LocaleKeys.readFailed_details.tr()),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(LocaleKeys.close.tr())),
            ],
          );
        });
  }

  Future AlertHaveBookAlready() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(LocaleKeys.downloadFail.tr()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(LocaleKeys.downloadFailDetails.tr()),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(LocaleKeys.close.tr())),
            ],
          );
        });
  }

  Future bookshelfMenuRead(
      pdfLink,
      bookTitle,
      bookId,
      bookDesc,
      bookshelfId,
      bookPrice,
      bookAuthor,
      bookNoOfPage,
      booktypeName,
      publisherName,
      bookIsbn,
      bookcateName,
      imgLink) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Column(
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (await checkfileBeforeReadPdf(fileBook: pdfLink ?? '')) {
                      Navigator.of(context).pop();
                      // Check file book in storage
                      if (checkTypeOfFile(pdfLink) == 'application/pdf') {
                        // check type of book is PDF
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ebookReader(
                                bookTitle: bookTitle ?? '',
                                fileBook: pdfLink ?? '',
                                book_id: bookId ?? '',
                              ),
                            ));
                      } else if (checkTypeOfFile(pdfLink) == 'video/mp4' ||
                          checkTypeOfFile(pdfLink) == 'audio/mpeg') {
                        // check type of book is Video
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => vdoPlayer(
                                bookTitle: bookTitle ?? '',
                                fileBook: pdfLink ?? '',
                              ),
                            ));
                      }
                    } else {
                      Navigator.of(context).pop();
                      AlertNoBook();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AnimeUI.cyan, // Background color
                  ),
                  icon: const Icon(
                    Icons.menu_book,
                    size: 24.0,
                  ),
                  label: Text(
                    '${LocaleKeys.read.tr()}             ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => detailPage(
                          bookId: bookId ?? '',
                          bookDesc: bookDesc ?? '',
                          bookshelfId: bookshelfId ?? '',
                          bookPrice: bookPrice ?? '',
                          bookTitle: bookTitle ?? '',
                          bookAuthor: bookAuthor ?? '',
                          bookNoOfPage: bookNoOfPage ?? '',
                          booktypeName: booktypeName ?? '',
                          publisherName: publisherName ?? '',
                          bookIsbn: bookIsbn ?? '',
                          bookcateId: '', // No data
                          bookcateName: bookcateName ?? '',
                          onlinetype: '', // No data
                          t2Id: '', // No data
                          imgLink: imgLink ?? '',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AnimeUI.cyan, // Background color
                  ),
                  icon: const Icon(
                    Icons.feed_rounded,
                    size: 24.0,
                  ),
                  label: Text(
                    '${LocaleKeys.detailsData.tr()}            ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    returnBook(
                        bookshelfId: bookshelfId ?? '',
                        DB_id: bookId ?? '',
                        pdfLink: pdfLink ?? '');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AnimeUI.cyan, // Background color
                  ),
                  icon: const Icon(
                    Icons.keyboard_return_outlined,
                    size: 24.0,
                  ),
                  label: Text(
                    '${LocaleKeys.returnBook.tr()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(LocaleKeys.close.tr())),
          ],
        );
      },
    );
  }

  Future bookshelfMenuDownload(
      pdfLink,
      bookTitle,
      bookId,
      bookDesc,
      bookshelfId,
      bookPrice,
      bookAuthor,
      bookNoOfPage,
      booktypeName,
      publisherName,
      bookIsbn,
      bookcateName,
      imgLink) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Column(
            children: [
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (await checkfileBeforeReadPdf(fileBook: pdfLink ?? '')) {
                      Navigator.of(context).pop();
                      AlertHaveBookAlready();
                    } else {
                      Navigator.of(context).pop();
                      download(pdfLink: pdfLink);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AnimeUI.cyan, // Background color
                  ),
                  icon: const Icon(
                    Icons.download,
                    size: 24.0,
                  ),
                  label: Text(
                    '${LocaleKeys.download.tr()}    ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => detailPage(
                          bookId: bookId ?? '',
                          bookDesc: bookDesc ?? '',
                          bookshelfId: bookshelfId ?? '',
                          bookPrice: bookPrice ?? '',
                          bookTitle: bookTitle ?? '',
                          bookAuthor: bookAuthor ?? '',
                          bookNoOfPage: bookNoOfPage ?? '',
                          booktypeName: booktypeName ?? '',
                          publisherName: publisherName ?? '',
                          bookIsbn: bookIsbn ?? '',
                          bookcateId: '', // No data
                          bookcateName: bookcateName ?? '',
                          onlinetype: '', // No data
                          t2Id: '', // No data
                          imgLink: imgLink ?? '',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AnimeUI.cyan, // Background color
                  ),
                  icon: const Icon(
                    Icons.feed_rounded,
                    size: 24.0,
                  ),
                  label: Text(
                    '${LocaleKeys.detailsData.tr()}            ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    returnBook(
                        bookshelfId: bookshelfId ?? '',
                        DB_id: bookId ?? '',
                        pdfLink: pdfLink ?? '');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AnimeUI.cyan, // Background color
                  ),
                  icon: const Icon(
                    Icons.keyboard_return_outlined,
                    size: 24.0,
                  ),
                  label: Text(
                    '${LocaleKeys.returnBook.tr()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(LocaleKeys.close.tr())),
          ],
        );
      },
    );
  }
}

showDataAlert(context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
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
