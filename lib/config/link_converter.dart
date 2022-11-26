import 'package:flutter/material.dart';
import 'package:webview_translator/presentation/pages/webview/webview_page.dart';

void linkConverter(String text, String fromLanguage, String toLanguage, BuildContext context) {
  if (text.isNotEmpty) {
    bool leftDot = false;
    bool hasQuestion = false;
    var urlList = text.split("");
    var newUrl = [];
    if (urlList.last != "/" && !text.contains(".htm")) {
      urlList.add('/');
    }
    for (var i = 0; i < urlList.length; i++) {
      if (urlList[i] == ".") {
        leftDot = true;
      }
      if (urlList[i] == "?") {
        hasQuestion = true;
      }
      if (urlList[i] == ".") {
        newUrl.add("-");
      } else if (urlList[i] == "/" && leftDot && !newUrl.contains(".translate.goog/")) {
        newUrl.add(".translate.goog/");
      } else {
        newUrl.add(urlList[i]);
      }
    }
    var headString = (text.contains("https://") || text.contains("www.")) ? "" : "https://";
    var routeUrl =
        "$headString${newUrl.join("")}${hasQuestion ? "&" : "?"}_x_tr_sl=$fromLanguage&_x_tr_tl=$toLanguage&_x_tr_hl=$toLanguage&_x_tr_pto=wapp";

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return WebViewPage(url: routeUrl, lastWebsite: text);
    }));
  }
}
