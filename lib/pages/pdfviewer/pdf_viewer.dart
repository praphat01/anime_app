import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'dart:io';
import '../../constants/colors.dart';
import 'package:pdfx/pdfx.dart';
import 'package:internet_file/internet_file.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ebookReader extends StatefulWidget {
  final String bookTitle;
  final String fileBook;

  const ebookReader({
    Key? key,
    required this.bookTitle,
    required this.fileBook,
  });

  @override
  State<ebookReader> createState() => _ebookReader(
        bookTitle: bookTitle,
        fileBook: fileBook,
      );
}

class _ebookReader extends State<ebookReader> {
  // final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  var localPath;
  Directory? directory;
  static const int _initialPage = 2;
  bool _isSampleDoc = true;
  late PdfController _pdfController;
  var file;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  String bookTitle;
  String fileBook;

  _ebookReader({
    required this.bookTitle,
    required this.fileBook,
  });

  Future<String?> _findLocalPath() async {
    // Directory? directory;
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await PathProviderAndroid()
            .getDownloadsPath(); //AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }

      directory = await getExternalStorageDirectory();
      String newPath = "";
      List<String> folders = directory!.path.split("/");

      for (int x = 1; x < folders.length; x++) {
        String folder = folders[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      externalStorageDirPath = newPath + "/Download/";
      externalStorageDirPath = externalStorageDirPath.substring(1);
      print('Arm is :${externalStorageDirPath}');
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  Future<String?> getPath() async {
    // localPath = '/storage/emulated/0/Download/';
    localPath = (await _findLocalPath())!;
    print('path is : ${localPath}');
    setState(() {
      localPath;
      file = '02006084.pdf';
      // final loadedPdfPageImage = '/storage/emulated/0/Download/02006084.pdf';
    });
  }

  @override
  void initState() {
    super.initState();
    getPath();
    _pdfController = PdfController(
      document:
          PdfDocument.openFile('/storage/emulated/0/Download/pdf-sample.pdf'),
      // document: PdfDocument.openData(
      //   InternetFile.get(
      //     'https://api.codetabs.com/v1/proxy/?quest=http://www.africau.edu/images/default/sample.pdf',
      //   ),
      // ),
      initialPage: _initialPage,
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AnimeUI.cyan, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          '${widget.bookTitle}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AnimeUI.cyan,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: AnimeUI.cyan,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.file(
        File('/storage/emulated/0/Download/${widget.fileBook}.pdf'),
        key: _pdfViewerKey,
        password: 'Staq021589623Staq',
        canShowPasswordDialog: false,
      ),
    );
  }

  // body: SfPdfViewer.file(
  //       File('/storage/emulated/0/Download/02005335.pdf'),
  //       password: 'staq021589623staq',
  //       canShowPasswordDialog: false,
  //     ),

  PhotoViewGalleryPageOptions _pageBuilder(
    BuildContext context,
    Future<PdfPageImage> pageImage,
    int index,
    PdfDocument document,
  ) {
    return PhotoViewGalleryPageOptions(
      imageProvider: PdfPageImageProvider(
        pageImage,
        index,
        document.id,
      ),
      minScale: PhotoViewComputedScale.contained * 1,
      maxScale: PhotoViewComputedScale.contained * 2,
      initialScale: PhotoViewComputedScale.contained * 1.0,
      heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
    );
  }
}
