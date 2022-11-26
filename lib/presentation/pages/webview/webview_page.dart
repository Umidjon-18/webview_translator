import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_translator/config/link_converter.dart';
import 'package:webview_translator/presentation/pages/home/home_page.dart';

import '../../../config/constants.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          ),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Simpl Solution", style: TextStyle(fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Visibility(
              visible: isVisible,
              child: const Center(
                child: CupertinoActivityIndicator(
                  radius: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
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
                    onWebViewCreated: (controller) async {
                      ctrl = controller;
                      controller.clearCache();
                    },
                    onProgress: (url) async {
                      // log(await ctrl.currentUrl());
                      progress();
                      // ctrl.evaluateJavascript(jsCode);
                    },
                    navigationDelegate: (navigation) {
                      log(navigation.url);

                      if (!navigation.url.contains(".translate.goog")) {
                        linkConverter(navigation.url, "auto", "ru", context);
                        return NavigationDecision.navigate;
                      } else {
                        return NavigationDecision.navigate;
                      }
                    },
                    onPageFinished: (url) {
                      finished();
                      // ctrl.evaluateJavascript(jsCode);
                    },
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
