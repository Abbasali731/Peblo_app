import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  TtsService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.1);
  }

  void setStartHandler(void Function() onStart) {
    _flutterTts.setStartHandler(onStart);
  }

  void setCompletionHandler(void Function() onComplete) {
    _flutterTts.setCompletionHandler(onComplete);
  }

  void setErrorHandler(void Function(dynamic message) onError) {
    _flutterTts.setErrorHandler(onError);
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      throw Exception("TTS Engine speaking failure: $e");
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {}
  }

  Future<void> dispose() async {
    await stop();

    _flutterTts.setStartHandler(() {});
    _flutterTts.setCompletionHandler(() {});
    _flutterTts.setErrorHandler((_) {});
  }
}
