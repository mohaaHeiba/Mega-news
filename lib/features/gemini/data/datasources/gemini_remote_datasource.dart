import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:mega_news/core/errors/api_exception.dart';

abstract class IGeminiRemoteDataSource {
  Future<String> generateText(String prompt);
}

class GeminiRemoteDataSourceImpl implements IGeminiRemoteDataSource {
  final Gemini _gemini;

  GeminiRemoteDataSourceImpl(this._gemini);

  @override
  Future<String> generateText(String prompt) async {
    try {
      final response = await _gemini.text(prompt);

      final text = response?.output;

      if (text != null && text.isNotEmpty) {
        return text;
      } else {
        throw ServerException(message: 'Gemini returned an empty response.');
      }
    } catch (e) {
      throw ServerException(message: 'Gemini API Error: ${e.toString()}');
    }
  }
}
