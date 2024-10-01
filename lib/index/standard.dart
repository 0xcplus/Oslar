//디자인 통합
import 'package:flutter/material.dart';

const double appSize = 0.8; //main.dart 반영. 비율 0.7 권장.
const double radiusChatImage = 40*appSize;
const roundedCorner = Radius.circular(22*appSize);

//글꼴 기초
TextStyle initTextStyle(
  { String font='NanumGothic', double fontSize=22, 
  FontStyle fontStyle = FontStyle.normal, FontWeight fontWeight = FontWeight.normal,
  color=const Color.fromARGB(255, 44, 44, 44),
  decoration=TextDecoration.none}
  ){ 
    return TextStyle(
      fontFamily: font,
      fontSize: fontSize*appSize,

      fontStyle: fontStyle,
      fontWeight: fontWeight,

      color: color,
      decoration: decoration,
    );
}

//그림자 기초
BoxShadow initShadowSetting({
  color = const Color.fromRGBO(0, 0, 0, 0.2), 
  double spreadRadius=5, double blurRadius=8, 
  Offset offset=const Offset(0, 4)}
  ){
    return BoxShadow(
      color: color,
      spreadRadius: spreadRadius,
      blurRadius: blurRadius,
      offset: offset,
  );
}