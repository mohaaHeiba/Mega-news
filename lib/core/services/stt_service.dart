import 'package:speech_to_text/speech_to_text.dart';

// speech to text
class STTService {
  final SpeechToText _speech = SpeechToText();

  // initialize + permission
  Future<bool> init() async {
    return await _speech.initialize();
  }

  Future<void> startListening(Function(String) onResult) async {
    bool available = await init();
    if (!available) return;

    _speech.listen(
      onResult: (result) => onResult(result.recognizedWords),
      listenFor: const Duration(seconds: 60),
      localeId: 'ar_EG', // We WIll add the English later
      partialResults: true,
    );
  }

  void stopListening() => _speech.stop();
  bool get isListening => _speech.isListening;
}
