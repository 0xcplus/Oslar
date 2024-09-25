import 'package:envied/envied.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY') // the .env variable.
  static String get apiKey => dotenv.env['OPEN_AI_API_KEY']??'dummy_key';
}