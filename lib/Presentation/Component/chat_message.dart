import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatefulWidget {
  ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      required this.isBot});

  late String text;
  final String sender;
  final bool isBot;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  GoogleTranslator translator = GoogleTranslator();
  bool isTranslate = false;

  // Google Translate
  void translate() {
    String lng = "";
    if (!isTranslate) {
      lng = "si";
    } else {
      lng = "en";
    }
    translator.translate(widget.text, to: lng).then((value) {
      setState(() {
        widget.text = value.toString();
        isTranslate = !isTranslate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBot) {
      return Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Text(widget.sender),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.isBot ? Colors.black38 : Colors.blueGrey),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Divider(),
                      IconButton(
                          onPressed: () => translate(),
                          icon: const Icon(Icons.recycling))
                    ],
                  ),
                ),
              )
            ],
          )),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.isBot ? Colors.black38 : Colors.blueGrey),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.text,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              child: Text(widget.sender),
            ),
          ),
        ],
      ).p16();
    }
  }
}
