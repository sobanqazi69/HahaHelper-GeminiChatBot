

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

const apiKey = "";//add your api key here
class withimage extends StatefulWidget {
  const withimage({super.key});

  @override
  State<withimage> createState() => _withimageState();
}

class _withimageState extends State<withimage> {
   bool loading = false;
  List textAndImageChat = [];
  File? imageFile;

  final ImagePicker picker = ImagePicker();

  final TextEditingController _textController = TextEditingController();
  final ScrollController _controller = ScrollController();

  // Create Gemini Instance
  final gemini = GoogleGemini(
    apiKey: apiKey,
  );

  void fromTextAndImage({required String query, required File image}) {
    setState(() {
      loading = true;
      textAndImageChat.add({
        "role": "User",
        "text": query,
        "image": image,
      });
      _textController.clear();
      imageFile = null;
    });
    scrollToTheEnd();

    gemini.generateFromTextAndImages(query: query, image: image).then((value) {
      setState(() {
        loading = false;
        textAndImageChat
            .add({"role": "HahaHelper", "text": value.text, "image": ""});
      });
      scrollToTheEnd();
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        textAndImageChat
            .add({"role": "Gemini", "text": error.toString(), "image": ""});
      });
      scrollToTheEnd();
    });
  }

  void scrollToTheEnd() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       floatingActionButton: imageFile != null
          ? Container(
              margin: const EdgeInsets.only(bottom: 80),
              height: 150,
              child: Image.file(imageFile ?? File("")),
            )
          : null,
    
      body: Column(children: [
          SizedBox(height: 10,),
          if (textAndImageChat.isEmpty) ...[Padding(
            padding:  EdgeInsets.only(top: Get.width* .4,left: 30),
            child: Center(child: Lottie.asset('assets/ask.json') ),
          )],
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: textAndImageChat.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    child: Text(textAndImageChat[index]["role"].substring(0, 1 , ), style: TextStyle(fontWeight: FontWeight.w400),),
                  ),
                  title: Text(textAndImageChat[index]["role"]),
                  subtitle: SelectableText(textAndImageChat[index]["text"]),
                  trailing: textAndImageChat[index]["image"] == ""
                      ? null
                      : Image.file(
                          textAndImageChat[index]["image"],
                          width: 90,
                        ),
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
              GestureDetector(
                child: Icon(Icons.image, color: Colors.deepOrange,),
                onTap: () async {
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    imageFile = image != null ? File(image.path) : null;
                  });
                },
              ),
              SizedBox(
                width: 10,
              ),
      
               loading
                              ? const CircularProgressIndicator()
                              : GestureDetector(
                child: Icon(Icons.send, color: Colors.deepOrange,),
                onTap: ()  {
                    if (imageFile == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Please select an image")));
                                      return;
                                    }
                                    fromTextAndImage(
                                        query: _textController.text,
                                        image: imageFile!);
                },
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ]),
    );
  }
}