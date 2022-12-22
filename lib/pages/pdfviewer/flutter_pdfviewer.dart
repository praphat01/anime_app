import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:path/path.dart' as paths;
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import '../../constants/colors.dart';
import '../../generated/locale_keys.g.dart';
import '../../models/m_widgets/bookmarks.dart';
import 'package:http/http.dart' as http;

class ebookReader extends StatefulWidget {
  final String bookTitle;
  final String fileBook;
  final String book_id;
  const ebookReader({
    Key? key,
    required this.bookTitle,
    required this.fileBook,
    required this.book_id,
  });

  @override
  State<ebookReader> createState() => _ebookReaderState(
        bookTitle: bookTitle,
        fileBook: fileBook,
        book_id: book_id,
      );
}

class _ebookReaderState extends State<ebookReader> {
  bool _isLoading = false;
  List<Result?> dataBookmark = [];
  PDFDocument? document;
  String bookTitle;
  String fileBook;
  String book_id;
  late PageController _pdfViewerController;

  _ebookReaderState({
    required this.bookTitle,
    required this.fileBook,
    required this.book_id,
  });

  void getBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? uniLink = prefs.getString('uniLink');

    var getBookmark = "${uniLink}/bookmarks.php?book_id=$book_id";
    final uri = Uri.parse(getBookmark);
    http.get(uri).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        setState(() {
          dataBookmark = bookmark.fromJson(decodedData).result as List<Result?>;
        });

        print(dataBookmark);
      } else {}
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfile();
    getBookmark();
    _pdfViewerController = PageController();
  }

  Future getfile() async {
    String urlBook = widget.fileBook.replaceAll("ebook_tab", "ebook_wm");

    File file = new File(widget.fileBook);
    String filename = paths.basename(file.path);
    String? mimeStr = lookupMimeType(filename);
    PDFDocument? doc = await PDFDocument.fromFile(await _localFile);
    setState(() {
      document = doc;
    });
  }

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();

    return directory!.path;
  }

  Future<File> get _localFile async {
    File file = new File(widget.fileBook);
    String filename = paths.basename(file.path);
    final path = await _localPath;
    return File('$path/$filename');
  }

  Widget modalBookmark() {
    return Container(
      height: 400.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
          itemCount: dataBookmark.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(
                  dataBookmark[index]!.title.toString(),
                  style: const TextStyle(fontSize: 15),
                ),
                trailing: Text(dataBookmark[index]!.page.toString()),
                onTap: () {
                  _pdfViewerController.jumpToPage(
                      int.parse(dataBookmark[index]!.page.toString()) - 1);
                  Navigator.of(context).pop();
                },
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.bookTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AnimeUI.cyan,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.format_list_bulleted_sharp,
                color: Colors.black, size: 30),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(LocaleKeys.contents.tr()),
                      content: modalBookmark(),
                    );
                  });

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => searchPage()),
              // );
            },
          ),
        ],
      ),
      body: pdf_viewer(),
    );
  }

  Widget pdf_viewer() {
    return document != null
        ? Center(
            child: PDFViewer(
              document: document!,
              lazyLoad: false,
              controller: _pdfViewerController,
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
