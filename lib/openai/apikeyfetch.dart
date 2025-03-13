import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:oslar/env/env.dart';

Future<String> returnApiKey() async {
  String apiKey;
  try { apiKey = await fetchApiKey(); }   //GitHub
  catch (e) {                             //Local(Web, Windows)
    print('This is not GitHub Pages : $e');
    await dotenv.load(fileName: "assets/config/.env");
    apiKey = Env.apiKey;
  }
  return apiKey;
}

Future<String> fetchApiKey() async {
  final response = await http.get(Uri.parse('https://solar-liart.vercel.app/api/getApiKey'));
  
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['apiKey'];
  } else {
    throw Exception('Failed to load API key');
  }
}