import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:my_app/Services/api_service.dart';
import 'package:translator/translator.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Component/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatGPT? chatGPT;
  StreamSubscription? _subscription;
  GoogleTranslator translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _sendMessage() async {
    ChatMessage _msg = ChatMessage(
      text: _msgController.text,
      sender: "User",
      isBot: false,
    );

    setState(() {
      _messages.insert(0, _msg);
    });
    _msgController.clear();
    String msg = "";
    await translator.translate(_msg.text, to: 'en').then((value) {
      msg = value.toString();
    });
    print(msg);
    var response = await ApiServices.sendMessage(msg);
    ChatMessage _botMessage = ChatMessage(
      text: response,
      sender: "Bot",
      isBot: true,
    );
    setState(() {
      _messages.insert(0, _botMessage);
    });

    // Setup Chat GPT
    // final request = CompleteReq(
    //     prompt: _msg.text, model: "text-davinci-003", max_tokens: 4000);
    // _subscription = chatGPT!
    //     .builder("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",
    //         orgId: "")
    //     .onCompleteStream(request: request)
    //     .listen((response) {
    //   Vx.log(response!.choices[0].text);
    //   ChatMessage botMessage =
    //       ChatMessage(text: response.choices[0].text, sender: "bot");
    //   setState(() {
    //     _messages.insert(0, botMessage);
    //   });
    // });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onSubmitted: (value) => _sendMessage(),
            decoration:
                const InputDecoration.collapsed(hintText: "Send a Message"),
            controller: _msgController,
          ),
        ),
        IconButton(
            onPressed: () => _sendMessage(), icon: const Icon(Icons.send))
      ],
    ).p16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("ChatGPT Model")),
      ),
      body: SafeArea(
        child: Column(children: [
          Flexible(
              child: ListView.builder(
                  reverse: true,
                  padding: Vx.m8,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  })),
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ]),
      ),
    );
  }
}
