import 'package:cloud_text_to_speech/src/google/voices/voice_model.dart';

class AudioRequestParamsGoogle {
  final VoiceGoogle voice;
  final String text;
  final String ssml;
  final String audioFormat;
  final String rate;
  final String pitch;

  AudioRequestParamsGoogle({
    required this.voice,
    required this.text,
    required this.audioFormat,
    required this.rate,
    required this.pitch,
  }) : ssml = '';

  AudioRequestParamsGoogle.fromSsml({
    required this.voice,
    required this.ssml,
    required this.audioFormat,
    required this.rate,
    required this.pitch,
  }) : text = '';
}
