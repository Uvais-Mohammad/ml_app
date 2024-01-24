import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_app/src/shared/services/speech_to_text/i_speech_to_text_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

final speechToTextServiceProvider = Provider<ISpeechToTextService>(
  (ref) => SpeechToTextService(),
);

final class SpeechToTextService implements ISpeechToTextService {
  final SpeechToText _speechToText = SpeechToText();

  @override
  Future<bool> initSpeech() async {
    return _speechToText.initialize(
      onError: (error) => debugPrint('Error: $error'),
      onStatus: (status) => debugPrint('Status: $status'),
      debugLogging: true,
      finalTimeout: const Duration(seconds: 10),
    );
  }

  @override
  void startListening(Function(SpeechRecognitionResult)? onResult) async {
    await _speechToText.listen(onResult: onResult);
  }

  @override
  void stopListening() async {
    await _speechToText.stop();
  }

  @override
  bool get isListening => _speechToText.isListening;
}
