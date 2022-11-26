import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

dynamic ctrl;

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key, required this.url});
  static const String id = "webview_page";
  final String url;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
    Timer(
      const Duration(seconds: 4),
      () => setState(() {
        isVisible = false;
      }),
    );
  }

  late String mainUrl = widget.url;
  late String appBarText = widget.url;
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Simpl Solution", style: TextStyle(fontSize: 20)),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: mainUrl,
                    onWebViewCreated: (controller) {
                      ctrl = controller;
                    },
                    onProgress: (url) {
                      ctrl.evaluateJavascript("document.getElementById('gt-nvframe').style.display='none';");
                    },
                    onPageFinished: (url) {
                      ctrl.evaluateJavascript("document.getElementById('gt-nvframe').style.display='none';");
                    },
                  ),
                  Visibility(
                    visible: isVisible,
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        radius: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
