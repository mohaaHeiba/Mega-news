import 'package:flutter_tts/flutter_tts.dart';

// text to speech
class TTSService {
  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text) async {
    await _tts.setLanguage('ar-EG'); // We WIll add the English later
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() async => await _tts.stop();
  Future<void> pauseSpeaking() async => await _tts.pause();
}
