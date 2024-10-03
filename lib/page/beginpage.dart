import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
//import 'dart:io' show Platform;

import 'chatpage.dart';
import '../index/standard.dart';

//지정
String url = 'https://github.com/0xcplus/Oslar/';
//StreamController<String> _streamController = StreamController<String>(); 
Color infLinkColor = const Color.fromARGB(255, 126, 141, 134);

//페이지 구성
class BeginPage extends StatefulWidget {
  const BeginPage({super.key, required this.title});
  final String title;

  @override
  State<BeginPage> createState() => _BeginPageState();
}

class _BeginPageState extends State<BeginPage> {
  //Stream<List<Widget>> messageStream = messageColumn();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: initTextStyle(
            fontWeight: FontWeight.bold,fontSize: 30, 
            color:const Color.fromARGB(255, 248, 248, 248),
          ),),
        elevation: 4,
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
      ),

      body: ChatArea(), //후에 바뀔 예정
      
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
                'Oslar', //수정해야하나?
                style: initTextStyle(
                  fontSize: 27, fontWeight: FontWeight.bold,
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
                cursor: SystemMouseCursors.click,
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
                      fontSize: 20,
                      color:infLinkColor, 
                      decoration: TextDecoration.underline,
                    )
                  ),
                ),
              ),

              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 93, 238, 204), //const Color.fromARGB(255, 85, 225, 160),
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