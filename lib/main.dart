//flutter
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//openai
import 'package:dart_openai/dart_openai.dart';

//etc.
import 'env/env.dart';
import 'page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName:"assets/config/.env");

  OpenAI.apiKey = Env.apiKey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 42, 42, 42),
          brightness: Brightness.light, // 라이트 모드
        ).copyWith(
          primary: const Color.fromARGB(255, 42, 42, 42), // 주 테마 색상
          onPrimary: Colors.white, // 주 테마 색상의 대비 텍스트
          secondary: Colors.green, // 보조 색상
          onSecondary: Colors.white, // 보조 색상의 대비 텍스트
          surface: Colors.white, // 표면 색상 (카드, 모달 등)
          onSurface: Colors.black, // 표면 색상에 쓰일 텍스트 색상
          error: Colors.red, // 에러 색상
          onError: Colors.white, // 에러 색상의 대비 텍스트
        ),
        useMaterial3: false, // Material 3 스타일 사용
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black), // 기본 텍스트 스타일
        ),
      ),
      home: const ChatPage(title: 'OpenAI API 활용'),
    );
  }
}