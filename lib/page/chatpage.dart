import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../UI/chatpage_ui.dart';
import '../function/openai.dart';
import '../UI/standard.dart';

//지정
String url = 'https://github.com/0xcplus/Oslar/';
StreamController<String> _streamController = StreamController<String>(); 

Map<String, dynamic> _mapMessage(String target, {String model='initGPT', String text='생각 중...'}){
  final time = DateTime.now();
  return {
    'model':model,    //기본값 GPT 4o
    'target':target,  //주체
    'text':text,
    'time':time
  };
}

//페이지 구성
class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.title});
  final String title;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List messageList = [];
  Color infLinkColor = const Color.fromARGB(255, 126, 141, 134);

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
          style: initTextStyle(fontSize: 30, color:const Color.fromARGB(255, 248, 248, 248),
          ),),
        elevation: 4,
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
      ),

      body:Column(
        children: <Widget>[
          ChatArea(messageList: messageList),
          InputTextArea(updateMessag : setStateMessage)
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    initShadowSetting()
                  ],
                ),

                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/oslar.png'), // 이미지
                ),
              ),

              //계정 이름
              accountName: Text(
                'Oslar', //수정 요망
                style: initTextStyle(
                  fontSize: 25,
                  color:const Color.fromARGB(255, 40, 40, 40)),
              ) ,

              //계정 이메일
              accountEmail: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    infLinkColor = const Color.fromARGB(255, 61, 55, 148);
                  });
                },
                onExit: (_) {
                  setState(() {
                    infLinkColor = const Color.fromARGB(255, 126, 141, 134);
                  });
                },
                child: GestureDetector(
                  onTap: () async{
                    final Uri uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)){
                      await launchUrl(uri);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    url,
                    style: initTextStyle(
                      color:infLinkColor, 
                      decoration: TextDecoration.underline,
                    )
                  ),
                ),
              ),

              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 85, 225, 192), //const Color.fromARGB(255, 85, 225, 160),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                boxShadow: [
                    initShadowSetting(spreadRadius: 3, blurRadius: 5)
                  ],
              ),
            ),

            //홈
            ListTile(
              leading: const Icon(Icons.home),
              title:Text('홈', style: initTextStyle()),
              onTap:(){},
              trailing: const Icon(Icons.navigate_next),
            ),

            //채팅
            ListTile(
              leading: const Icon(Icons.chat),
              title:Text('채팅', style: initTextStyle()),
              onTap:(){},
              trailing: const Icon(Icons.navigate_next),
            ),

             //설정
            ListTile(
              leading: const Icon(Icons.settings),
              title:Text('설정', style: initTextStyle()),
              onTap:(){},
              trailing: const Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
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
          itemBuilder: (BuildContext context, int index){
            bool isUser = (widget.messageList[index]['target']!='Assistant'); // 수정 요망
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
  final FocusNode focusInputTextfield = FocusNode();
  final TextEditingController _controller = TextEditingController();

   void _onButtonPressed() {
    if(_controller.text.isNotEmpty){
      final text = _controller.text;
      widget.updateMessag('User', text);
      _controller.clear();
    }
  }

  @override
  void dispose(){
    focusInputTextfield.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Container(
            height:100,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 248, 248, 248),
              boxShadow: [initShadowSetting(spreadRadius: 5, blurRadius: 12)], // 위로 적용될 그림자 설정
            ),
          ),
        ),

        Column(
          children: [
            const Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 11, 15, 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    //child : KeyboardListener(
                      //focusNode: focusInputTextfield,
                      child : TextField(
                        controller: _controller,
                        focusNode: focusInputTextfield,
                        onSubmitted: (value) {
                          _onButtonPressed();
                          focusInputTextfield.requestFocus(); 
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter your message',
                        ),
                      ),
                    //),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      _onButtonPressed();
                      focusInputTextfield.requestFocus(); 
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}