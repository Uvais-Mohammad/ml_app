import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:ml_app/src/shared/services/translation/i_translation_service.dart';

final translationServiceProvider = Provider<ITranslationService>(
  (ref) => TranslationService(
    sourceLanguage: TranslateLanguage.english,
    targetLanguage: TranslateLanguage.hindi,
    modelManager: OnDeviceTranslatorModelManager(),
  ),
);

final class TranslationService implements ITranslationService {
  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;
  final OnDeviceTranslatorModelManager _modelManager;
  final OnDeviceTranslator _onDeviceTranslator;

  TranslationService({
    required this.sourceLanguage,
    required this.targetLanguage,
    required OnDeviceTranslatorModelManager modelManager,
  })  : _onDeviceTranslator = OnDeviceTranslator(
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
        ),
        _modelManager = modelManager;

  @override
  Future<String> getTranslation(String text) async {
    final translation = await _onDeviceTranslator.translateText(text);
    debugPrint('translation: $translation');
    return translation;
  }

  @override
  Future<bool> downloadModel() async {
    return _modelManager.downloadModel(TranslateLanguage.hindi.bcpCode);
  }
}
