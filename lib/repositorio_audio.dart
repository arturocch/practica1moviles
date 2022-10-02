import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practica_1_audio/datos_cancion.dart';

class repositorio_audio {
  final String apiToken = 'd7fdd6ae2bea8f14a3f42bdfed3e0b27';
  final Uri url = Uri.parse('https://api.audd.io/');

  Future<DatosCancion?> recognizeSong(String encodedFile) async {
    var response = await http.post(url, body: {
      'api_token': apiToken,
      'audio': encodedFile,
      'return': 'apple_music,spotify,deezer',
    });
    try {
      return DatosCancion.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)) as Map);
    } catch (e) {
      return null;
    }
  }
}
