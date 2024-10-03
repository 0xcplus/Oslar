//flutter & dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

//openai
import 'package:dart_openai/dart_openai.dart';

//etc.
import 'env/env.dart';
import 'page/beginpage.dart';
import 'index/standard.dart';

String errorFind = "";

Future<void> main() async{
  //WidgetsFlutterBinding.ensureInitialized();

  String apiKey;
  try { apiKey = await fetchApiKey(); }   //GitHub
  catch (e) {                             //Local(Web, Windows)
    print('It could be not the GitHub Pages : $e');
    await dotenv.load(fileName: "assets/config/.env");
    apiKey = Env.apiKey;
  }

  OpenAI.apiKey = apiKey;
  runApp(const MyApp());
}

//favicon.png
Future<String> fetchApiKey() async {
  final response = await http.get(Uri.parse('https://solar-liart.vercel.app/api/getApiKey'));
  
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
      title: 'Oslar',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 70, 70, 70),
          brightness: Brightness.light, // 라이트 모드
        ).copyWith(
          primary: const Color.fromARGB(255, 71, 71, 71), // 주 테마 색상
          onPrimary: Colors.white, // 주 테마 색상의 대비 텍스트
          secondary: const Color.fromARGB(255, 100, 241, 171), // 보조 색상
          onSecondary: const Color.fromARGB(255, 242, 242, 242), // 보조 색상의 대비 텍스트
          surface: const Color.fromARGB(255, 238, 238, 238), // 표면 색상 (카드, 모달 등)
          onSurface: Colors.black, // 표면 색상에 쓰일 텍스트 색상
          error: const Color.fromARGB(255, 231, 141, 135), // 에러 색상
          onError: Colors.white, // 에러 색상의 대비 텍스트
        ),
        useMaterial3: false, // Material 3 스타일 사용

        // 기본 텍스트 스타일
        textTheme: TextTheme(
          bodyLarge: initTextStyle(),
        ),
      ),

      home: const BeginPage(title: 'Oslar'),
    );
  }
}