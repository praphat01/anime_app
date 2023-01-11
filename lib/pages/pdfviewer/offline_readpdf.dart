// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

import 'package:anime_app/models/sqlite_model.dart';

class OfflineReadPdf extends StatefulWidget {
  const OfflineReadPdf({
    Key? key,
    required this.sqLiteModel,
  }) : super(key: key);

  final SQLiteModel sqLiteModel;

  @override
  State<OfflineReadPdf> createState() => _OfflineReadPdfState();
}

class _OfflineReadPdfState extends State<OfflineReadPdf> {
  PDFDocument? pdfDocument;

  @override
  void initState() {
    super.initState();
    loadPdfDocument();
  }

  Future<void> loadPdfDocument() async {
    
        await PDFDocument.fromFile(File(widget.sqLiteModel.book_file)).then((value) {
          pdfDocument = value;
          setState(() {
            
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sqLiteModel.book_name),
      ),
      body: pdfDocument == null ? const SizedBox() :  PDFViewer(document: pdfDocument!),
    );
  }
}
