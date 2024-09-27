import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const double appSize = 0.7; //main.dart 반영. 비율 0.7 권장.
const double radius = 40*appSize;
const roundedCorner = Radius.circular(22*appSize);

TextStyle initTextStyle(
  { String font='NanumGothic', 
  double fontSize=22, 
  color=const Color.fromARGB(255, 44, 44, 44),
  decoration=TextDecoration.none}) { 
    return TextStyle(
      fontFamily: font,
      fontSize: fontSize*appSize,
      color: color,
      decoration: decoration,
    );
}

BoxShadow initShadowSetting({double spreadRadius=5, double blurRadius=8}){
    return BoxShadow(
      color: Colors.black.withOpacity(0.2),
      spreadRadius: spreadRadius,
      blurRadius: blurRadius,
      offset: const Offset(0, 4),
  );
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
              decoration: const BoxDecoration(
                color:Color.fromRGBO(146, 251, 183, 1),
                borderRadius: BorderRadius.only(
                  topLeft: roundedCorner,
                  topRight: Radius.circular(7*appSize),
                  bottomLeft: roundedCorner,
                  bottomRight: roundedCorner
                )
              ),
              child: Text(
                message['text'],
                style: initTextStyle(),
              ),
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
          padding: const EdgeInsets.all(3*appSize),
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
            borderRadius: BorderRadius.circular(2*radius), //80
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                width: radius*1.4,
                height: radius*1.4,
                fit: BoxFit.cover,
                ),
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
                      style: initTextStyle(),
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
                        child: Text(
                          message['text'],
                          style: initTextStyle(),
                        ),
                      );
                    }
                  )
                ],
              ),

              const SizedBox(width: 4*appSize),
              Padding(
                padding: const EdgeInsets.only(top: 10*appSize), // 적절한 위치 조정을 위해 패딩 추가
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