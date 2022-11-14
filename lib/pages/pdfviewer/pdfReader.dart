
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

  Future<void> loadPDF() async {
   
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
      body: Container(
          child: SfPdfViewer.network(
            'https://www.2ebook.com/new/assets/ebook_tab/nlt/02006099.pdf',
            password:'Staq021589623Staq',
            canShowPasswordDialog: false,)));
}
}
