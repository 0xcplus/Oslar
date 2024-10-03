import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io' show Platform;

import 'chatpagemsg.dart';
import '../index/standard.dart';
import '../function/openai.dart';

String url = 'https://github.com/0xcplus/Oslar/';
StreamController<String> streamController = StreamController<String>(); 

List messageList = [];              //수정 필요
String exampleModel = 'initGPT';    //현 모델 initGPT, reasonGPT, exampleGPT

class ChatArea extends StatefulWidget {
  //final List messageList;
  const ChatArea({super.key});

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea>{
  ScrollController scrollController = ScrollController();

  void setStateMessage(target, text) {
    setState(() {
      messageList.add(mapMessage(target, text:text)); //setState
    });

    final number = messageList.length; //현재까지의 리스트 길이
    messageList.add(mapMessage('assistant'));

    streamController = StreamController<String>(); 
    fetchStreamedResponse(text, exampleModel, streamController);

    streamController.stream.listen((response){
      setState(() {
        messageList[number]['text']=response; 
      });
    }, onDone: (){
      setState(() {
        messageList[number]['processed']=1;
      });
    }, onError: (error){
      print('Error Code : $error');
    }, );
  }

  @override
  Widget build(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
       duration: const Duration(milliseconds: 10), curve: Curves.ease);
    });

    //TARGET에 의해 결정되므로 chatmode.dart 참고
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            
            child:Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount:messageList.length+1,
                    itemBuilder: (BuildContext context, int index){
                      if (index == messageList.length) {
                        return const SizedBox(height: 20); // 여백 추가
                      }
                      bool isUser = (messageList[index]['target']!='assistant'); // 수정 요망
                      return isUser? buildMyMsg(context, messageList[index],)
                      :buildOtherMsg(context, messageList[index]);
                    }
                  ),
                ),
              ]
            )
          ),
        ),
        InputTextArea(updateMessag: setStateMessage)
      ]
    );
  }
}

class InputTextArea extends StatefulWidget {
  final Function updateMessag;
  const InputTextArea({super.key, required this.updateMessag});
 
  @override
  State<InputTextArea> createState() => _InputTextAreaState();
}

class _InputTextAreaState extends State<InputTextArea> {
  final FocusNode _focusInputTextfield = FocusNode();
  final TextEditingController _controller = TextEditingController();

   void _onButtonPressed() {
    if(_controller.text.isNotEmpty){
      final text = _controller.text;
      widget.updateMessag('user', text);
      _controller.clear();
    }
  }

  @override
  void dispose(){
    _focusInputTextfield.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 250, 250),
        boxShadow: [initShadowSetting(
          color: const Color.fromRGBO(0, 0, 0, 0.5),
          spreadRadius: 5,
          blurRadius: 12,
        )],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(5), // 아래쪽 모서리를 둥글게
        ),
      ),

      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
            child: Row(
              children: <Widget>[
                // 입력창
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: 6,
                    controller: _controller,
                    focusNode: _focusInputTextfield,
                    onSubmitted: (value) {
                      _onButtonPressed();
                      if (!(Platform.isIOS || Platform.isAndroid)) _focusInputTextfield.requestFocus();
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '입력창',
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                // 전송 버튼
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _onButtonPressed();
                    if (!(Platform.isIOS || Platform.isAndroid))  _focusInputTextfield.requestFocus();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}