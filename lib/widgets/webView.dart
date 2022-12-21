import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class WebViewExample extends StatefulWidget {
  final String pathWebSite;
  final String uniSname;

  const WebViewExample(
      {Key? key, required this.uniSname, required this.pathWebSite})
      : super(key: key);

  // WebViewExampleState({required this.pathWebSite, required this.uniSname});

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  String? registerUrl = '';
  String? qqq = '';
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    getData();
  }

  void getData() async {
    final String? uniSname = widget.uniSname;
    final String? pathWebSite = widget.pathWebSite;

    // final prefs = await SharedPreferences.getInstance();
    // final String? uniLink = prefs.getString('uniLink');
    // final String? pathWebSite = prefs.getString('pathWebSite');

    // print('testsssss url : ${pathWebSite}');
    // print('uni id => ${uniSname}');
    registerUrl = pathWebSite!.replaceAll("index", "register");
    if (registerUrl!.contains('www.2ebook.com/new')) {
    } else {
      registerUrl = '${registerUrl}/library/register/${uniSname}';
    }

    setState(() {
      registerUrl;
    });
  }

  // https://www.2ebook.com/new/library/register/nlt
  // http://ebook.sg.ac.th/library/register
  // www.2ebook.com/new/library/index/nlt

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: registerUrl,
    );
  }
}
