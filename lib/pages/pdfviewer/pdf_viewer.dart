import 'dart:io';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:path/path.dart' as path;

import '../../constants/colors.dart';

class ebookReader extends StatefulWidget {
  final String bookTitle;
  final String fileBook;
  const ebookReader({
    Key? key,
    required this.bookTitle,
    required this.fileBook,
  });

  @override
  State<ebookReader> createState() => _ebookReaderState(
        bookTitle: bookTitle,
        fileBook: fileBook,
      );
}

class _ebookReaderState extends State<ebookReader> {
  bool _isLoading = false;

  PDFDocument? document;
  String bookTitle;
  String fileBook;

  _ebookReaderState({
    required this.bookTitle,
    required this.fileBook,
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getfile();
  }

  // Future<String> get _localPath async {
  //   final directory = await getExternalStorageDirectory();

  //   return directory!.path;
  // 999

  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/02006099.pdf');
  // }

  // Future<int> readCounter() async {
  //   try {
  //     final file = await _localFile;

  //     // Read the file
  //     final contents = await file.readAsString();

  //     return int.parse(contents);
  //   } catch (e) {
  //     // If encountering an error, return 0
  //     return 0;
  //   }
  // }

  Future getfile() async {
    // print('##Arm File book ${widget.fileBook}');
    // var appDocDir = await getExternalStorageDirectory();
    // String nameFile = "/02006099.pdf";
    // String savePath = appDocDir!.path + nameFile;

    // var files = await _localFile;
    // print('##Arm path is ==> ${files}');
    // File files = File(await _localPath);
    // PDFDocument doc = await PDFDocument.fromFile(files);

    String urlBook = widget.fileBook.replaceAll("ebook_tab", "ebook_wm");

    // File file = new File(widget.fileBook);
    // String filename = path.basename(file.path);
    // print(filename);
    PDFDocument? doc = await PDFDocument.fromURL(urlBook);
    setState(() {
      document = doc;
    });
  }

  // Future<PDFDocument?> loadFromAssets() async {
  //   try {
  //     setState(() {
  //       _isLoading = true; //show loading
  //     });
  //     File files = File(await _localPath);
  //     document = await PDFDocument.fromFile(files);
  //     setState(() {
  //       _isLoading = false; //remove loading
  //     });
  //     return document;
  //   } catch (err) {
  //     print('Caught error: $err');
  //   } //catch
  // } //Future

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.bookTitle}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AnimeUI.cyan,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(child: PDFViewer(document: document!)),
    );
  }
}
