import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_app/src/shared/services/speech_to_text/i_speech_to_text_service.dart';
import 'package:ml_app/src/shared/services/speech_to_text/speech_to_text_service.dart';

final speechToTextProvider =
    StateNotifierProvider<SpeechToTextProvider, (String, bool)>(
  (ref) => SpeechToTextProvider(
    speechToTextService: ref.read(speechToTextServiceProvider),
  ),
);

class SpeechToTextProvider extends StateNotifier<(String, bool)> {
  SpeechToTextProvider({
    required ISpeechToTextService speechToTextService,
  })  : _speechToTextService = speechToTextService,
        super(('', false));

  final ISpeechToTextService _speechToTextService;

  void updateText(String text) {
    state = (text, _speechToTextService.isListening);
  }

  void initSpeech() async {
    final bool isInitialized = await _speechToTextService.initSpeech();
    debugPrint('Speech to text initialized: $isInitialized');
  }

  void startListening() {
    state = ('', true);
    _speechToTextService.startListening((result) {
      debugPrint('result: ${result.recognizedWords}');
      updateText(result.recognizedWords);
    });
  }
}
