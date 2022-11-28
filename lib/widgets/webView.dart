import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    getData();
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? pathWebSite = prefs.getString('pathWebSite');
    print('testsssss url : ${pathWebSite}');
  }

  // https://www.2ebook.com/new/library/register/nlt
  // http://ebook.sg.ac.th/library/register

  // www.2ebook.com/new/library/index/nlt

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'http://ebook.sg.ac.th/library/register',
    );
  }
}
