abstract interface class ITranslationService {
  Future<String> getTranslation(String text);
  Future<bool> downloadModel();
}