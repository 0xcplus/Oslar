import 'package:flutter/material.dart';
import '../UI/standard.dart';

Map<String, dynamic> _chatSet(String target, String modelVersion, String asset, {String information = 'Original ChatGPT Model'}){
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
  _chatSet('initGPT', 'gpt-4o-mini','assets/images/logo.png')
];

String findChatVersion(String target){
  return chatMode.firstWhere(
    (chat) => chat['target'] == target,
    orElse: () => null,
  )['modelVersion'];
}

Image findChatImage(String target) {
  return chatMode.firstWhere(
    (chat) => chat['target'] == target,
    orElse: () => null,
  )['image'];
}