import 'package:speech_to_text/speech_recognition_result.dart';

abstract interface class ISpeechToTextService {
  Future<bool> initSpeech();
  void startListening(Function(SpeechRecognitionResult)? onResult);
  void stopListening();
  bool get isListening;
}
