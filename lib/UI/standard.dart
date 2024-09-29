//디자인 통합
import 'package:flutter/material.dart';

const double appSize = 0.8; //main.dart 반영. 비율 0.7 권장.
const double radiusChatImage = 40*appSize;
const roundedCorner = Radius.circular(22*appSize);

//글꼴 기초
TextStyle initTextStyle(
  { String font='NanumGothic', 
  double fontSize=22, 
  color=const Color.fromARGB(255, 44, 44, 44),
  decoration=TextDecoration.none}
  ){ 
    return TextStyle(
      fontFamily: font,
      fontSize: fontSize*appSize,
      color: color,
      decoration: decoration,
    );
}

//그림자 기초
BoxShadow initShadowSetting({double spreadRadius=5, double blurRadius=8}){
    return BoxShadow(
      color: Colors.black.withOpacity(0.2),
      spreadRadius: spreadRadius,
      blurRadius: blurRadius,
      offset: const Offset(0, 4),
  );
}