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
  //numbering
  _regaxSet(RegExp(r'^\d+\.\s+.*?(?=\n|$)'), Text, style: initTextStyle(fontSize: 30)),
  _regaxSet(RegExp(r'(?:(?<=\n)|^)#{1,}\s+(\S.+)(?=\n|$)'), Text, style: initTextStyle( //r'^#{1,}\s+(\S.+)'
    fontSize: 27, fontWeight: FontWeight.bold)
    ),

  //code / Container 최대치 5
  _regaxSet(RegExp(r'`{5,}\s*([\s\S]*?)\s*`{5,}'),Container, style: initTextStyle(font: 'NanumGothicCoding')),  //RegExp(r'`{5,}\s*(.*?)\s*`{5,}')
  _regaxSet(RegExp(r'`{4}\s*([\s\S]*?)\s*`{4}'),Container, style: initTextStyle(font: 'NanumGothicCoding')),  
  _regaxSet(RegExp(r'`{3}\s*([\s\S]*?)\s*`{3}',),Container, style: initTextStyle(font: 'NanumGothicCoding')), //(r'`{3}\s*(.*?)\s*`{3}') > code?
  _regaxSet(RegExp(r'`{2}\s*(\S.+)\s*`{2}'),Text, style: initTextStyle(font: 'NanumGothicCoding', color: const Color.fromARGB(255, 134, 0, 0))),  //(r'`{2}\s*(.*?)\s*`{2}')
  _regaxSet(RegExp(r'\`{1,}(\S.+)\`{1,}',), Text, style: initTextStyle(font: 'NanumGothicCoding', color: const Color.fromARGB(255, 134, 0, 0))), //RegExp(r'\`{1,}(.*?)\`{1,}',)

  //horizon
  _regaxSet(RegExp(r'^\s*-{3,}\s*$'),Divider), //r'^-{3}\s+(?=\n)'
  _regaxSet(RegExp(r'^\s*_{3,}\s*$'),Divider), //r'^_{3}\s+(?=\n)'
  _regaxSet(RegExp(r'^\s*\*{3,}\s*$'),Divider),

  //emphasize
  _regaxSet(RegExp(r'^-\s+(\S.+)(?=\n|$)'),Text, style: initTextStyle(color: Colors.blue)),
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
    String textInProgress = widget.message['text'];
    print('${widget.message['text']}\n');
    //print(textInProgress);

    List<InlineSpan> result = [];

    print('\n==.==.==.==.==');

    if(isDone==0){ //마크다운 적용 완료가 아닐 경우.
      result = _applyMarkdownToNewData(textInProgress);
      //print('Result Widgets : $result');

      widget.message['stacked']=result;
      if(widget.message['target']=='user') {widget.message['processed']=200;}
    } else if(isDone==1){
      result = _applyMarkdownToNewData(textInProgress);
      print('last one +++ text ${widget.message['text']} \n\n Widgets : $result');

      List<TextSpan> addTextSpan = [];
      List<InlineSpan> finalResultList = [];
      //InlineSpan ifEmpty = const TextSpan();

      print('${result.length} whats the probrem? $result');

      for(InlineSpan span in result){
        print(span.runtimeType);
        if(span is TextSpan){
          addTextSpan.add(span);
          //ifEmpty=span;
        }
        else{
          print('therere datas');
          finalResultList.add(WidgetSpan(child: SelectableText.rich(TextSpan(children: addTextSpan))));
          finalResultList.add(span);
          addTextSpan = [];
        }
      }
      //finalResultList.add(addTextSpan);

      print('finalresult : $finalResultList');

      widget.message['stacked']=[...finalResultList,...addTextSpan];

      widget.message['processed']=200;
      print("+++it's end.+++ ${widget.message['processed']}");
    } else {print('/////////// this is done already /////////////');}

    print('\n==.==.==.==.==');
  }

  @override
  Widget build(BuildContext context) {
    //print('build ${widget.message['stacked']}');
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
              color: Color.fromRGBO(168, 168, 168, 0.5),
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
        resultWidget=const WidgetSpan(child: Divider(color: Color.fromARGB(255, 40, 40, 40), thickness: 1));
      } else {
        resultWidget=TextSpan(text: match.group(1), style: regData['style']);
      }
    } else {
      resultWidget=TextSpan(text: 'Debug! : ${match.group(1)}', style: initTextStyle());
    }
    return resultWidget;
  }
}