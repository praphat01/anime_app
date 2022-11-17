import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ebookReader extends StatefulWidget {
  const ebookReader({Key? key}) : super(key: key);

  @override
  State<ebookReader> createState() => _ebookReaderState();
}

class _ebookReaderState extends State<ebookReader> {
  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.file(
        File(
            '/storage/emulated/0/Android/data/com.example.anime_app/files/02006099.pdf'),
        password: 'Staq021589623Staq',
        canShowPasswordDialog: false,
      ),
    );
  }
}
