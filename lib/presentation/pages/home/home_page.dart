import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_translator/config/constants.dart';
import 'package:webview_translator/config/link_converter.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController textEditingController = TextEditingController()..text = globalLastWebsite;
  final GlobalKey<ScaffoldState> key = GlobalKey();
  String fromLanguage = languages[164]["code"];
  String toLanguage = languages[134]["code"];

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
                onChanged: (value) {
                  globalLastWebsite = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter the link',
                  hintStyle: const TextStyle(color: Colors.black26),
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
                      linkConverter(textEditingController.text, fromLanguage, toLanguage, context);

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
          onPressed: () {
            linkConverter(textEditingController.text, fromLanguage, toLanguage, context);
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
    );
  }
}
