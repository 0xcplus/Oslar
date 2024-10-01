//ChatGPT 기반 코드
import 'package:flutter/material.dart';
import 'package:oslar/index/standard.dart';
//import 'package:flutter/gestures.dart';

//마크다운 정리
Map<String, dynamic> _regaxSet(RegExp regax, Type type, {TextStyle style=const TextStyle()}){
  return {
    'regax':regax,
    'type':type,
    'style':style,
  };
}

List _regaxList = [ //마크다운 우선순위
  //code / Container 최대치 5
  _regaxSet(RegExp(r'`{5,}\s*([\s\S]*?)\s*`{5,}'),Container, style: initTextStyle(font: 'NanumGothicCodingLigature')),  //RegExp(r'`{5,}\s*(.*?)\s*`{5,}')
  _regaxSet(RegExp(r'`{4}\s*([\s\S]*?)\s*`{4}'),Container, style: initTextStyle(font: 'NanumGothicCodingLigature', color: Colors.red)),  
  _regaxSet(RegExp(r'`{3}\s*([\s\S]*?)\s*`{3}',),Container, style: initTextStyle(font: 'NanumGothicCodingLigature')), //(r'`{3}\s*(.*?)\s*`{3}') > code?
  _regaxSet(RegExp(r'`{2}\s*(\S.+)\s*`{2}'),Container, style: initTextStyle(font: 'NanumGothicCodingLigature')),  //(r'`{2}\s*(.*?)\s*`{2}')
  _regaxSet(RegExp(r'\`{1,}(\S.+)\`{1,}',), Container, style: initTextStyle(font: 'NanumGothicCodingLigature', color: Colors.yellow)), //RegExp(r'\`{1,}(.*?)\`{1,}',)

  //horizon
  _regaxSet(RegExp(r'^-{3}\s+(.*)'),Divider),
  //_regaxSet(RegExp(r'^_{3}\s+(.*)'),Divider), //이것도
  //_regaxSet(RegExp(r'^\*{3}\s+(.*)'),Divider), //이거 위험할지도

  //emphasize
  _regaxSet(RegExp(r'^#{1,}\s+(\S.+)'), Text, style: initTextStyle(
    color: Colors.purple, fontSize: 25, fontWeight: FontWeight.bold)
    ),
  _regaxSet(RegExp(r'^-\s+(\S.+)'),Text, style: initTextStyle(color: Colors.blue)),
      //(String content) => SelectableText(content, style: const TextStyle(color:Colors.blue, fontSize: 22))),


  //italic + bold > itabold
  _regaxSet(RegExp(r'\*{3}(.*?)\*{3}'), Text, 
    style:initTextStyle(
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold
    )
  ), 
  _regaxSet(RegExp(r'\_{3}(.*?)\_{3}'), Text, 
    style:initTextStyle(
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold
    )
  ), 

  _regaxSet(RegExp(r'\*{2}(.*?)\*{2}'),  Text, style: initTextStyle(fontWeight: FontWeight.bold)),
  _regaxSet(RegExp(r'\_{2}(.*?)\_{2}'), Text, style:initTextStyle(fontWeight: FontWeight.bold)),

  _regaxSet(RegExp(r'\*(\S.+)\*'), Text, style:initTextStyle(fontStyle: FontStyle.italic)),
  _regaxSet(RegExp(r'\_(\S.+)\_'), Text, style:initTextStyle(fontStyle: FontStyle.italic)),
];

//마크다운 적용 italic, bold, itabold, code
class MarkdownText extends StatefulWidget {
  final Map message;
  const MarkdownText({super.key, required this.message});

  @override
  _MarkdownTextState createState() => _MarkdownTextState();
}

class _MarkdownTextState extends State<MarkdownText> { 
  @override
  void didUpdateWidget(MarkdownText oldWidget) {
    print("====================start========================");
    super.didUpdateWidget(oldWidget);
    
    int isDone= widget.message['processed'];
    String textInProgress = widget.message['text']; //.replaceAll('\n', ''); //.replaceAll('\n', '');
    print('${widget.message}\n\n $isDone \n');
    //print(textInProgress);

    List<InlineSpan> result = [];

    print('\n==.==.==.==.==');

    if(isDone==0){ //마크다운 적용 완료가 아닐 경우.
      result = _applyMarkdownToNewData(textInProgress);
      print('Result Widgets : $result');

      widget.message['stacked']=result;
      if(widget.message['target']=='user') {widget.message['processed']=200;}
      print("it's end."); //?

    } else if(isDone==1){
      result = _applyMarkdownToNewData(textInProgress);
      print('last one +++ Widgets : $result');

      widget.message['stacked']=result;
      widget.message['processed']=200;
      print("+++it's end.+++ ${widget.message['processed']}");
    } else {print('///////////this is done already ${widget.message['processed']} /////////////');}

    print('\n==.==.==.==.==');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.message['stacked'].map<Widget>((span) {
      if (span is WidgetSpan) {
        return span.child;
      } else if (span is TextSpan) {
        return SelectableText.rich(TextSpan(children:[span], style: initTextStyle()));
      } else {
        return Container();
        }
      }
    ).toList());
  }

  List<InlineSpan> _applyMarkdownToNewData(String text) { 
    bool matched = false;
    List<InlineSpan> resultList = [];
    print('progress >>> $text');
    print('재귀함수');

    for (var regData in _regaxList) { //재귀함수
      if (regData['regax'].hasMatch(text)) {
        RegExpMatch match = regData['regax'].firstMatch(text);
        print('I FOUNT IT! ${regData['regax']}');

        List<InlineSpan> beforeMatch = _applyMarkdownToNewData(text.substring(0, match.start));
        List<InlineSpan> afterMatch = _applyMarkdownToNewData(text.substring(match.end));
        List<InlineSpan> matchedMatch = [_matchMarkDown(text.substring(match.start, match.end), regData)];

        resultList = beforeMatch+matchedMatch+afterMatch;
        matched = true;
        print('goodbye $resultList');
        break;
      }
    }

    if(!matched) { resultList = [TextSpan(text: text, style: initTextStyle())];}
    return resultList;
  }

  InlineSpan _matchMarkDown(String text, Map regData) {
    InlineSpan resultWidget = const TextSpan();
    print(text);

    final match = regData['regax'].firstMatch(text);

    if (match != null) {
      if (match.start > 0) {
        resultWidget=TextSpan(text: text.substring(0, match.start));
      }

      Type type = regData['type'];

      if (type == Container) {
        print('container');
        resultWidget=WidgetSpan(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 66, 66, 66),
            ),
            padding: const EdgeInsets.all(1),
            child: SelectableText(
              match.group(1),
              style: regData['style'],
            ),
          ),
        );
      } else if (type == Divider) {
        print('divider');
        resultWidget=const WidgetSpan(child: Divider(color: Colors.grey, thickness: 1));
      } else {
        resultWidget=TextSpan(text: match.group(1), style: regData['style']);
      }
    } else {
      resultWidget=TextSpan(text: 'Debug! : ${match.group(1)}', style: initTextStyle());
    }
    return resultWidget;
  }
}