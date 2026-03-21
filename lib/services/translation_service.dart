import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService extends ChangeNotifier {
  late OnDeviceTranslator _translator;
  bool _isReady = false;
  TranslateLanguage _targetLanguage = TranslateLanguage.russian;

  bool get isReady => _isReady;

  TranslationService() {
    _initTranslator();
  }

  Future<void> _initTranslator() async {
    // Проверяем/скачиваем модель (нужен интернет 1 раз)
    final modelManager = OnDeviceTranslatorModelManager();
    final bool isDownloaded = await modelManager.isModelDownloaded(_targetLanguage.code);
    
    if (!isDownloaded) {
      await modelManager.downloadModel(_targetLanguage.code);
    }

    _translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: _targetLanguage,
    );
    _isReady = true;
    notifyListeners();
  }

  Future<String> translate(String text) async {
    if (!_isReady) return text;
    return await _translator.translateText(text);
  }

  @override
  void dispose() {
    _translator.close();
    super.dispose();
  }
}