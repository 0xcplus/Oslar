//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../function/chatmode.dart';
import '../function/markdown.dart';
import '../index/standard.dart';

Map<String, dynamic> mapMessage(
  String target,
  {String model='initGPT', String text='생각 중...', int processed=0}
  ){
  final time = DateTime.now();
  return {
    'model':model,    //기본값 GPT 4o
    'target':target,  //주체
    'text':text,      //메시지
    'stacked':<InlineSpan>[TextSpan(text: text)],     //마크다운 처리
    'processed':processed,
    'time':time
  };
}

Widget buildMyMsg(BuildContext context, Map message) {
  final String time = DateFormat('HH:mm').format(message['time']);

  return Padding(
    padding: const EdgeInsets.fromLTRB(0*appSize,20*appSize,10*appSize,0*appSize),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
            time,
             style: initTextStyle(fontSize: 14),
          ),
        const SizedBox(width:4),

        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 14*appSize, horizontal: 18*appSize),
              constraints: BoxConstraints(
                minHeight: 40*appSize,
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              decoration: BoxDecoration(
                color:const Color.fromARGB(255, 93, 238, 204), //Color.fromRGBO(146, 251, 183, 1),
                borderRadius: const BorderRadius.only(
                  topLeft: roundedCorner,
                  topRight: Radius.circular(7*appSize),
                  bottomLeft: roundedCorner,
                  bottomRight: roundedCorner
                ),
                border: Border.all(
                  color: const Color.fromRGBO(1, 1, 1, 0.1),
                  width: 2*appSize,
                ),
              ),

              child: MarkdownText(message:message) //SelectableText(message['text'], style: initTextStyle()) //, //마크다운 해제
            );
          },
        ),
      ],
    ),
  );
}

Widget buildOtherMsg(BuildContext context, Map message) {
  final String time = DateFormat('HH:mm').format(message['time']);

  return Padding(
    padding: const EdgeInsets.fromLTRB(10*appSize,15*appSize,0*appSize,3*appSize),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4*appSize),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color.fromRGBO(84, 235, 177, 1),
                Color.fromRGBO(110, 249, 219, 0.694),
                Color.fromRGBO(60, 157, 243, 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(2*radiusChatImage), //80
          ),
          child: CircleAvatar(
            radius: radiusChatImage,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
            child: ClipOval(
              child: findChatImage('initGPT'), //initGPT 접근
            ),
          ),
        ),
        const SizedBox(width: 10*appSize),

        // Column으로 묶기
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment:  MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3*appSize),
                    child: Text(
                      'ChatGPT',
                      style: initTextStyle(font: 'NanumGothicBold', fontSize: 27),
                    ),
                  ),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 14*appSize, horizontal: 18*appSize),
                        constraints: BoxConstraints(
                          minHeight: 40,
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(7*appSize),
                            topRight: roundedCorner,
                            bottomLeft: roundedCorner,
                            bottomRight: roundedCorner
                          ),
                          border: Border.all(
                            color: const Color.fromRGBO(1, 1, 1, 0.095),
                            width: 2*appSize,
                          ),
                        ),

                        //child:

                        child: MarkdownText(message: message),
                      );
                    }
                  )
                ],
              ),

              const SizedBox(width: 4*appSize),
              Padding(
                padding: const EdgeInsets.only(top: 10*appSize),
                child: Text(
                  time,
                  style: initTextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}