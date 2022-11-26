import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_translator/main.dart';

dynamic ctrl;

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key, required this.url});
  final String url;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool isVisible = true;
  late String mainUrl = widget.url;
  late String appBarText = widget.url;

  String jsCode = "document.getElementById('gt-nvframe').style.display='none';";

  String userAgent =
      "Mozilla/5.0 (Linux; U; Android 4.4.2; en-us; SCH-I535 Build/KOT49H) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  void progress() {
    setState(() {
      isVisible = true;
    });
  }

  void finished() {
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // log(mainUrl);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    userAgent: userAgent,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: mainUrl,
                    onWebViewCreated: (controller) {
                      ctrl = controller;
                    },
                    onProgress: (url) {
                      progress();
                      ctrl.evaluateJavascript(jsCode);
                    },
                    onPageFinished: (url) {
                      finished();
                      ctrl.evaluateJavascript(jsCode);
                    },
                  ),
                  Visibility(
                    visible: isVisible,
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        radius: 15,
                        color: Colors.black,
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
