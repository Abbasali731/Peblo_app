import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/tts_service.dart';

enum AudioState { idle, preparing, reading, completed, error }

class AudioNotifier extends StateNotifier<AudioState> {
  final TtsService _ttsService;

  AudioNotifier(this._ttsService) : super(AudioState.idle) {
    _ttsService.setStartHandler(() {
      state = AudioState.reading;
    });
    _ttsService.setCompletionHandler(() {
      state = AudioState.completed;
    });
    _ttsService.setErrorHandler((err) {
      state = AudioState.error;
    });
  }

  Future<void> speakStory(String text) async {
    if (state == AudioState.preparing || state == AudioState.reading) return;

    state = AudioState.preparing;

    await Future.delayed(const Duration(milliseconds: 1200));

    if (state != AudioState.preparing) return;

    try {
      await _ttsService.speak(text);
    } catch (e) {
      state = AudioState.error;
    }
  }

  Future<void> stop() async {
    await _ttsService.stop();
    state = AudioState.idle;
  }

  void reset() {
    state = AudioState.idle;
  }
}

final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  final ttsService = ref.watch(ttsServiceProvider);
  return AudioNotifier(ttsService);
});
