import 'package:flutter/material.dart';
import '../index/standard.dart';

Map<String, dynamic> _chatSet(
  String target, String modelVersion, String asset, 
  {String information = 'Original ChatGPT Model'}
  ){
  return {
    'target':target,
    'modelVersion':modelVersion,
    'image':Image.asset(
      asset,
      width:radiusChatImage*1.4,
      height: radiusChatImage*1.4,
      fit:BoxFit.cover
      ),
    'information':information,
  };
}

//Chat 모드 설정
List chatMode = [
  _chatSet('initGPT', 'gpt-4o-mini','assets/images/logo.png'),
  _chatSet('reasonGPT', 'o1-mini', 'assets/images/logo.png', information: 'Model for Reasoning'), //'o1-preview'
];

//추출 함수
String findChatVersion(String target){
  return findChatMode(target)['modelVersion'];
}

Image findChatImage(String target) {
  return findChatMode(target)['image'];
}

Map<String, dynamic> findChatMode(String target){
  return chatMode.firstWhere(
    (chat) => chat['target'] == target,
    orElse: () => null,
  );
}