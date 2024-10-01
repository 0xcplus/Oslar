//ChatGPT 기반 코드
import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';
//import '../index/standard.dart';

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
  _regaxSet(RegExp(r'`{5,}\s*(.*?)\s*`{5,}'),Container),
  _regaxSet(RegExp(r'`{4}\s*(.*?)\s*`{4}'),Container),
  _regaxSet(RegExp(r'`{3}\s*(.*?)\s*`{3}',),Container),
  _regaxSet(RegExp(r'`{2}\s*(.*?)\s*`{2}'),Container),
  _regaxSet(RegExp(r'\`{1,}(.*?)\`{1,}',), Container),

  //horizon
  _regaxSet(RegExp(r'^-{3}\s+(.*)'),Divider),
  _regaxSet(RegExp(r'^_{3}\s+(.*)'),Divider),
  _regaxSet(RegExp(r'^\*{3}\s+(.*)'),Divider),

  //emphasize
  _regaxSet(RegExp(r'^#{1,}\s+(.*)'), Text),
      //(String content) => SelectableText(content, style: const TextStyle(color:Colors.green, fontSize: 22))),
  _regaxSet(RegExp(r'^-{1}\s+(.*)'),Text),
      //(String content) => SelectableText(content, style: const TextStyle(color:Colors.blue, fontSize: 22))),


  //italic + bold > itabold
  _regaxSet(RegExp(r'\*{3}(.*?)\*{3}'), Text, 
    style:const TextStyle(
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold
    )
  ), 
  _regaxSet(RegExp(r'\_{3}(.*?)\_{3}'), Text, 
    style:const TextStyle(
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold
    )
  ), 

  _regaxSet(RegExp(r'\*{2}(.*?)\*{2}'),  Text, style: const TextStyle(fontWeight: FontWeight.bold)),
  _regaxSet(RegExp(r'\_{2}(.*?)\_{2}'), Text, style:const TextStyle(fontWeight: FontWeight.bold)),

  _regaxSet(RegExp(r'\*(.*?)\*'), Text, style:const TextStyle(fontStyle: FontStyle.italic)),
  _regaxSet(RegExp(r'\_(.*?)\_'), Text, style:const TextStyle(fontStyle: FontStyle.italic)),
];

//마크다운 적용 italic, bold, itabold, code
class MarkdownText extends StatefulWidget {
  final Map message;
  const MarkdownText({super.key, required this.message});

  @override
  _MarkdownTextState createState() => _MarkdownTextState();
}

/*  'model':model,    //기본값 GPT 4o
    'target':target,  //주체
    'text':text,      //메시지
    'markdown':[],    //마크다운
    'time':time*/

class _MarkdownTextState extends State<MarkdownText> { 
  List<InlineSpan> _resultData = [];
  List<InlineSpan> _stackedData = [];

  @override
  void didUpdateWidget(MarkdownText oldWidget) {
    print("===start===");
    super.didUpdateWidget(oldWidget);
    
    bool isCorrect = widget.message['text'].split('\n').length 
                      > widget.message['stacked'].split('\n').length;

    print('\n\ntext : ${widget.message['text']} \nstacked : ${widget.message['stacked']}\n');

    print('mark down. ${widget.message['markdown']}');
    print(isCorrect);

    if (widget.message['text'] != widget.message['stacked']) { //갱신될 경우 작동
      print(widget.message['markdown']);
      String textInProgress = widget.message['text'].split('\n')
        .where((item)=>!_stackedData.contains(item)).toList()[0];
      
      print('hi this is your text : $textInProgress ');

      InlineSpan result = _applyMarkdownToNewData(textInProgress);

      _resultData = [result];
      widget.message['markdown'] = result;

      print('result data : $_resultData');
      print('result : $result');

      if(!isCorrect) {_stackedData=[result];}
      print('stacked data : $_stackedData');

      widget.message['stacked'] = widget.message['text'];
      print("\n\n==========\n\n");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _stackedData.map((span) {
        if (span is WidgetSpan) {
          return span.child;
        } else if (span is TextSpan) {
          return SelectableText.rich(TextSpan(children:[span]));
        } else {
          return Container();
        }
      }).toList(),
    );
  }

InlineSpan _applyMarkdownToNewData(String text) { 
  bool matched = false;
  InlineSpan newChildren = const TextSpan();
  print('progress >>> $text');

    for (var regData in _regaxList) {
      if (regData['regax'].hasMatch(text)) {
        print('I FOUNT IT!');
        matched = true;
        newChildren=_matchMarkDown(text, regData);
        break;
      }
    }
    if(!matched) newChildren=TextSpan(text: text);
    return newChildren;
  }

  InlineSpan _matchMarkDown(String _text, Map regData) {
    InlineSpan result = const TextSpan();

    while (_text.isNotEmpty) {
      final match = regData['regax'].firstMatch(_text);

      if (match != null) {
        if (match.start > 0) {
          result=TextSpan(text: _text.substring(0, match.start));
        }

        Type type = regData['type'];

        if (type == Container) {
          result=WidgetSpan(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              padding: const EdgeInsets.all(1),
              child: SelectableText(
                match.group(1) ?? '',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        } else if (type == Divider) {
          result=const WidgetSpan(child: Divider(color: Colors.grey, thickness: 1));
        } else {
          result=TextSpan(text: match.group(1) ?? '', style: regData['style']);
        }
        _text = _text.substring(match.end);
      } else {
        result=TextSpan(text: _text);
        break;
      }
    }
    
    return result;
  }
}


/*class MarkdownText extends StatelessWidget {
  final String data;
  const MarkdownText({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> children = [TextSpan(text: '$data ')];
    print('\n');
    print('children : $children');
    
    //for (var regData in _regaxList) {
      children = _applyMarkdown(children, _regaxList[1]);
    //}

    print('==result==');
    print('children : $children');
    print('\n');

    //위젯 분리
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((span){
        if (span is WidgetSpan) {
          return span.child;
        } else if (span is TextSpan){
          return SelectableText.rich(TextSpan(children:[span]));
        } else {
          return Container();
        }
      }).toList(),
    );
  }
}

List<InlineSpan> _applyMarkdown(List<InlineSpan> children, Map regData) {
  List<InlineSpan> newChildren = [];

  for (InlineSpan span in children) {
    if (span is TextSpan) {
      String text = span.text ?? '';

      // 개행 문자를 기준으로 텍스트를 나눈다.
      List<String> paragraphs = text.split('\n');

      for (int i = 0; i < paragraphs.length; i++) {
        print(regData);
        List<InlineSpan> styledSpans = _matchMarkDown(paragraphs[i], regData);

        if (styledSpans.length == 1 && styledSpans[0] is TextSpan && styledSpans[0].style == null) {
          newChildren.add(TextSpan(text: paragraphs[i], style: span.style));
        } else {
          for (var styledSpan in styledSpans) {
            if (styledSpan is TextSpan) {
              TextStyle? mergedStyle = span.style?.merge(styledSpan.style) ?? styledSpan.style;
              newChildren.add(TextSpan(text: styledSpan.text, style: mergedStyle));
            } else if (styledSpan is WidgetSpan){
              newChildren.add(styledSpan);
            }
          }
        }

      }
    } else {
      newChildren.add(span); // 다른 종류의 InlineSpan일 경우 그대로 추가
    }
  }
  return newChildren;
}

//변경 필요
List<InlineSpan> _matchMarkDown(String remainingText, Map regData) {
  final List<InlineSpan> children = [];

  while (remainingText.isNotEmpty) {
    final match = regData['regax'].firstMatch(remainingText);

    if (match != null) {
      if (match.start > 0) {
        children.add(TextSpan(text: remainingText.substring(0, match.start)));
      }

    //print(regData);
    print(regData['type']);
    
    Type type = regData['type'];

      if (type==Container){
        print('container');
        children.add(WidgetSpan(
          child:Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            padding: const EdgeInsets.all(1),
            child: SelectableText(
              match.group(1), 
              style: const TextStyle(color: Colors.red)
            )
          )
        )
      );//SelectableText(match.group(1))//
      } else if (type==Divider) {
        print('divider');
        children.add(const WidgetSpan(child: Divider(color: Colors.grey, thickness: 1)
        ));
      } else {
        print('text');
        children.add(TextSpan(text: match.group(1), style:regData['style']));
      }
      remainingText = remainingText.substring(match.end);
    }
    else { print('debug'); children.add(TextSpan(text: remainingText)); break; }
  }
  print('===========');
  print(children);
  print('\n====================================\n');
  return children;
}*/