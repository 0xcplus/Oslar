import 'package:envied/envied.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'env.g.dart';

@Envied(path:".env") //"assets/.env")
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY')
  static const String apiKey = _Env.apiKey;

  /*static String get apiKey {
    try {
      return dotenv.env['OPEN_AI_API_KEY'] ?? 'dummy_key';     
    } catch (e) {
      print('Error loading API key: $e');
      return 'fatal error;';
    }
  }*/
}