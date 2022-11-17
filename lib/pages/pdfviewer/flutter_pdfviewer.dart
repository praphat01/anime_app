import 'dart:io';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:path/path.dart' as paths;
import 'package:mime/mime.dart';
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

  Future getfile() async {
    String urlBook = widget.fileBook.replaceAll("ebook_tab", "ebook_wm");

    File file = new File(widget.fileBook);
    String filename = paths.basename(file.path);
    // print(filename);

    String? mimeStr = lookupMimeType(filename);
    // var fileType = mimeStr.split('/');
    // print('file type ${mimeStr}');
    // if (mimeStr == 'application/pdf') {
    //   print('##type is yes');
    // } else {
    //   print('##type is NO');
    // }

    PDFDocument? doc = await PDFDocument.fromFile(await _localFile);

    // PDFDocument? doc = await PDFDocument.fromURL(urlBook);
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
      body: pdf_viewer(),
    );
  }

  Widget pdf_viewer() {
    return document != null
        ? Center(child: PDFViewer(document: document!))
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
