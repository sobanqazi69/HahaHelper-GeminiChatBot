// ignore_for_file: camel_case_types, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini/chatscreen.dart';
import 'package:get/route_manager.dart';
import 'package:google_gemini/google_gemini.dart';

import 'package:lottie/lottie.dart';

class withoutimage extends StatefulWidget {
  const withoutimage({super.key});

  @override
  State<withoutimage> createState() => _withoutimageState();
}

class _withoutimageState extends State<withoutimage> {
  bool loading = false;
  List textChat = [];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  // Create Gemini Instance
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  void fromText({required String query}) {
    setState(() {
      loading = true;
      textChat.add({
        "role": "User",
        "text": query,
      });
      _textController.clear();
    });
    scrollToTheEnd();

    gemini.generateFromText(query).then((value) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "HahaHelper",
          "text": value.text,
        });
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textChat.add({
          "role": "Gemini",
          "text": error.toString(),
        });
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 10,
      ),
      if (textChat.isEmpty) ...[
        Padding(
          padding: EdgeInsets.only(top: Get.width * .4, left: 30),
          child: Center(child: Lottie.asset('assets/ask.json')),
        )
      ],
      Expanded(
        child: ListView.builder(
          controller: _controller,
          itemCount: textChat.length,
          padding: const EdgeInsets.only(bottom: 20),
          itemBuilder: (context, index) {
            return ListTile(
              isThreeLine: true,
              leading: CircleAvatar(
                backgroundColor: Colors.deepOrange,
                child: Text(
                  textChat[index]["role"].substring(
                    0,
                    1,
                  ),
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
              title: Text(textChat[index]["role"]),
              subtitle: SelectableText(textChat[index]["text"]),
            );
          },
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: TextFormField(
                  controller: _textController,
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Write a Message',
                    contentPadding:
                        const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(height: 0),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ))),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 10,
          ),
          loading
              ? const CircularProgressIndicator()
              : GestureDetector(
                  child: Icon(
                    Icons.send,
                    color: Colors.deepOrange,
                  ),
                  onTap: () {
                    fromText(
                      query: _textController.text,
                    );
                  },
                ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      SizedBox(
        height: 20,
      ),
    ]);
  }
}
