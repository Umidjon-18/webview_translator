import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_translator/config/constants.dart';

import '../webview/webview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
late TextEditingController textEditingController = TextEditingController()..text = "hepsiburada.com";
  final GlobalKey<ScaffoldState> key = GlobalKey();
  String fromLanguage = languages[0]["code"];
  String toLanguage = languages[41]["code"];

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: key,
      appBar: AppBar(
        actions: [
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.white),
                color: Colors.white30,
              ),
              child: TextField(
                style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w500),
                autocorrect: false,
                textAlignVertical: TextAlignVertical.center,
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: 'Enter the link',
                  hintStyle: const TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        textEditingController.text = "";
                      });
                    },
                    icon: Icon(
                      CupertinoIcons.clear_thick,
                      color: Colors.black.withOpacity(.5),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              key.currentState!.openEndDrawer();
            },
            icon: const Icon(Icons.menu, size: 32),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("From Language", style: TextStyle(fontSize: 20)),
                Container(
                  width: double.maxFinite,
                  height: 50,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    value: fromLanguage,
                    underline: const SizedBox(),
                    items: List.generate(
                      languages.length,
                      (index) => DropdownMenuItem(
                        key: Key(languages[index]["code"]),
                        value: languages[index]["code"],
                        child: Text(languages[index]["name"]),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        fromLanguage = value.toString();
                      });
                    },
                  ),
                ),
                const Text("To Language", style: TextStyle(fontSize: 20)),
                Container(
                  width: double.maxFinite,
                  height: 50,
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    value: toLanguage,
                    underline: const SizedBox(),
                    items: List.generate(
                      languages.length,
                      (index) => DropdownMenuItem(
                        key: Key(languages[index]["code"]),
                        value: languages[index]["code"],
                        child: Text(languages[index]["name"]),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        toLanguage = value.toString();
                      });
                    },
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      fetchWebsite(textEditingController.text);
                      key.currentState!.closeEndDrawer();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: const Text(
                        "Open",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => fetchWebsite(textEditingController.text),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: const Text(
              "Open",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }

  fetchWebsite(String text) {
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
      var headString = (text.contains("https://")|| text.contains("www.")) ? "" :  "https://";
      var routeUrl =
          "$headString${newUrl.join("")}${hasQuestion ? "&" : "?"}_x_tr_sl=$fromLanguage&_x_tr_tl=$toLanguage&_x_tr_hl=$toLanguage&_x_tr_pto=wapp";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(
            url: routeUrl,
          ),
        ),
      );
    }
  }
}
