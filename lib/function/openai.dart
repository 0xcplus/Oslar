import 'dart:async';
import 'package:dart_openai/dart_openai.dart';

//ChatGPT 함수
final requestMessages = [OpenAIChatCompletionChoiceMessageModel(
  content: [
    OpenAIChatCompletionChoiceMessageContentItemModel.text(
      'helpful assistant',
    ),
  ],
  role: OpenAIChatMessageRole.assistant,
)];

Future<void> fetchStreamedResponse(String inputMessage, StreamController<String> streamController) async {
  final userMessage = OpenAIChatCompletionChoiceMessageModel(
    content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(
        inputMessage,
      ),
    ],
    role: OpenAIChatMessageRole.user,
  ); requestMessages.add(userMessage);

  String result = '';

  try{
    final chatStream = OpenAI.instance.chat.createStream(
      model: "gpt-4o-mini",
      messages: requestMessages
    );

    await for (var streamChatCompletion in chatStream) {
      if (streamChatCompletion.choices.isNotEmpty){
        final content = streamChatCompletion.choices.first.delta.content;
        if (content != null && content.isNotEmpty) {
          for (var item in content) {
            if(item != null){
              final text = item.text??'';
              result += text;
              streamController.add(result);
            }
          }
        }
      }
    }
  } catch(e) {
    print('Error fetching streamed response : $e');
    streamController.add('오류 발생 : $e');
  } finally {
    streamController.close();
  }

  final systemMessage = OpenAIChatCompletionChoiceMessageModel(
    content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(
        result,
      ),
    ],
    role: OpenAIChatMessageRole.assistant,
  ); requestMessages.add(systemMessage);
}