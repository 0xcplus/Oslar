import 'dart:async';
import 'package:flutter/material.dart';
import 'ui.dart';
import 'chatgpt.dart';

StreamController<String> _streamController = StreamController<String>(); 

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.title});
  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List messageList = [];

  void setStateMessage(target, text) {
    setState(() {
      messageList.add(_mapMessage(target, text:text));
    });

    final number = messageList.length; //현재까지의 리스트 길이
    messageList.add(_mapMessage('Assistant'));

    _streamController = StreamController<String>(); 
    fetchStreamedResponse(text, _streamController);

    _streamController.stream.listen((response){
      setState((){
        messageList[number]['text']=response;
      });
    }, onError: (error){
      print('Error Code : $error');
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Helvetica',
          ),),
        elevation: 5,
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
      ),
      body:Column(
        children: <Widget>[
          ChatArea(messageList: messageList),
          InputTextArea(updateMessag : setStateMessage)
        ],
      )
    );
  }
}

class ChatArea extends StatefulWidget {
  final List messageList;
  const ChatArea({super.key, required this.messageList});

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea>{
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
       duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child:ListView.builder(
          controller: scrollController,
          itemCount:widget.messageList.length,
          itemBuilder: (BuildContext context, int index){ // 메세지
            bool isUser = (widget.messageList[index]['target']!='Assistant');
            return isUser? buildMyMsg(context, widget.messageList[index])
            :buildOtherMsg(context, widget.messageList[index]);
          }
        )
      )
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
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose(){
    _controller.dispose();
    //_streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        const Divider(thickness: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 11, 15, 15),
          child: Row(
            children:<Widget>[
              Expanded(
                child : TextField( //입력창
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your message',
                  ),
                ),
              ),
              const SizedBox(width: 15),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if(_controller.text.isNotEmpty){
                    final text = _controller.text;
                    widget.updateMessag('User', text);
                    _controller.clear();
                  }
                }
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Map<String, dynamic> _mapMessage(String target, {String text='생각 중...'}){
  final time = DateTime.now();
  return {
    'target':target,
    'text':text,
    'time':time
  };
}