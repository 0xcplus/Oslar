//flutter
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

//openai
import 'package:dart_openai/dart_openai.dart';

//etc.
import 'env/env.dart';
import 'page.dart';

Future<void> main() async{
  //WidgetsFlutterBinding.ensureInitialized();

  String apiKey;
  try {
    apiKey = await fetchApiKey();
    print('worked!');
  } catch (e) {
    print('Error fetching API key: $e');

    await dotenv.load(fileName: "assets/config/.env");
    apiKey = Env.apiKey;
  }

  OpenAI.apiKey = apiKey;

  runApp(const MyApp());
}

Future<String> fetchApiKey() async {
  final response = await http.get(Uri.parse('http://localhost:3000/api/getApiKey')); 
    // local  :  'http://localhost:3000/api/getApiKey'
    //github  :  'https://oslar-onzqufq35-0xcplus-projects.vercel.app/api/getApiKey';
  
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['apiKey'];
  } else {
    throw Exception('Failed to load API key');
  }
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