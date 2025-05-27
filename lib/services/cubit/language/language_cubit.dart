import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translator/translator.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial()) {
    _loadSavedLanguage();
  }

  final GoogleTranslator _translator = GoogleTranslator();
  String _currentLanguage = 'en'; // Default to English
  Map<String, String> translationCache = {};

  String get currentLanguage => _currentLanguage;
  bool get isArabic => _currentLanguage == 'ar';
  bool get isEnglish => _currentLanguage == 'en';

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString('selected_language') ?? 'en';
      emit(LanguageChanged(language: _currentLanguage));
    } catch (e) {
      emit(LanguageError(error: e.toString()));
    }
  }

  Future<void> toggleLanguage() async {
    try {
      emit(LanguageLoading());
      // Toggle between English and Arabic
      _currentLanguage = _currentLanguage == 'en' ? 'ar' : 'en';

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', _currentLanguage);

      // Clear translation cache when language changes
      translationCache.clear();

      emit(LanguageChanged(language: _currentLanguage));
    } catch (e) {
      emit(LanguageError(error: e.toString()));
    }
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      if (_currentLanguage == languageCode) return;

      emit(LanguageLoading());
      _currentLanguage = languageCode;

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', _currentLanguage);

      // Clear translation cache
      translationCache.clear();

      emit(LanguageChanged(language: _currentLanguage));
    } catch (e) {
      emit(LanguageError(error: e.toString()));
    }
  }

  Future<String> translateText(String text, {String? fromLanguage}) async {
    try {
      // If current language is English, return original text
      if (_currentLanguage == 'en') return text;

      // Check if it's a unit that needs special translation
      String lowerText = text.toLowerCase().trim();
      if (unitTranslations.containsKey(lowerText)) {
        return unitTranslations[lowerText]!;
      }

      // Check cache first
      String cacheKey = '${text}_${fromLanguage ?? 'en'}_$_currentLanguage';
      if (translationCache.containsKey(cacheKey)) {
        return translationCache[cacheKey]!;
      }

      // Translate text
      Translation translation = await _translator.translate(
        text,
        from: fromLanguage ?? 'en',
        to: _currentLanguage,
      );

      String translatedText = translation.text;

      // Cache the translation
      translationCache[cacheKey] = translatedText;

      return translatedText;
    } catch (e) {
      print('Translation error: $e');
      return text; // Return original text if translation fails
    }
  }

  Future<Map<String, String>> translateMultiple(
    List<String> texts, {
    String? fromLanguage,
  }) async {
    Map<String, String> translations = {};

    for (String text in texts) {
      translations[text] = await translateText(
        text,
        fromLanguage: fromLanguage,
      );
    }

    return translations;
  }

  Map<String, String> unitTranslations = {
    'tsps': 'ملاعق صغيرة',
    'tsp': 'ملعقة صغيرة',
    'tbsp': 'ملعقة كبيرة',
    'tbsps': 'ملاعق كبيرة',
    'cup': 'كوب',
    'cups': 'أكواب',
    'oz': 'أونصة',
    'lb': 'رطل',
    'lbs': 'أرطال',
    'g': 'جرام',
    'kg': 'كيلوجرام',
    'ml': 'مل',
    'l': 'لتر',
    'inch': 'بوصة',
    'inches': 'بوصات',
    'clove': 'فص',
    'cloves': 'فصوص',
    'slice': 'شريحة',
    'slices': 'شرائح',
    'piece': 'قطعة',
    'pieces': 'قطع',
  };

  Future<String> translateForSearch(String searchText) async {
    try {
      // If text is in Arabic, translate to English for search
      if (isArabic) {
        // Check cache first
        String cacheKey = '${searchText}_ar_en';
        if (translationCache.containsKey(cacheKey)) {
          return translationCache[cacheKey]!;
        }

        // Translate to English
        Translation translation = await _translator.translate(
          searchText,
          from: 'ar',
          to: 'en',
        );

        String translatedText = translation.text.toLowerCase();

        // Cache the translation
        translationCache[cacheKey] = translatedText;

        return translatedText;
      }

      // If text is in English, return as is
      return searchText.toLowerCase();
    } catch (e) {
      print('Search translation error: $e');
      return searchText; // Return original text if translation fails
    }
  }
}
