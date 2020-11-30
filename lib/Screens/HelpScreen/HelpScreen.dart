import 'package:flutter/material.dart';
import 'package:smscontroller/constants.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpScreen extends StatelessWidget {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: kWhiteColor,
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),
    ));
  }

  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/index.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
