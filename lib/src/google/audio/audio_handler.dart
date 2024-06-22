import 'dart:convert';

import 'package:cloud_text_to_speech/src/google/audio/audio_client.dart';
import 'package:cloud_text_to_speech/src/google/audio/audio_request_param.dart';
import 'package:cloud_text_to_speech/src/google/audio/audio_response_mapper.dart';
import 'package:cloud_text_to_speech/src/google/audio/audio_responses.dart';
import 'package:cloud_text_to_speech/src/google/auth/authentication_types.dart';
import 'package:cloud_text_to_speech/src/google/common/constants.dart';
import 'package:cloud_text_to_speech/src/google/ssml/ssml.dart';
import 'package:http/http.dart' as http;

class AudioHandlerGoogle {
  Future<AudioSuccessGoogle> getAudio(AudioRequestParamsGoogle params, AuthenticationHeaderGoogle authHeader) async {
    final client = http.Client();
    final audioClient = AudioClientGoogle(
      client: client,
      authHeader: authHeader,
    );
    final mapper = AudioResponseMapperGoogle();

    try {
      final Map<String, dynamic> body = {
        'input': {},
        'voice': {'name': params.voice.code, 'languageCode': params.voice.locale.code},
        'audioConfig': {
          'pitch': params.pitch,
          'speakingRate': params.rate,
          'audioEncoding': params.audioFormat,
        },
      };

      if (params.ssml.isNotEmpty) {
        final ssml = SsmlGoogle(text: params.ssml, rate: params.rate, pitch: params.pitch);

        body['input']['ssml'] = ssml.sanitizedSsml;
      } else {
        body['input']['text'] = params.text;
      }

      final String bodyJson = jsonEncode(body);

      final response = await audioClient.post(Uri.parse(EndpointsGoogle.tts), body: bodyJson);
      final audioResponse = mapper.map(response);
      if (audioResponse is AudioSuccessGoogle) {
        return audioResponse;
      } else {
        throw audioResponse;
      }
    } catch (e) {
      rethrow;
    }
  }
}
