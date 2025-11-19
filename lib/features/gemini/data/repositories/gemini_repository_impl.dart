import 'package:mega_news/core/errors/api_exception.dart';
import 'package:mega_news/features/gemini/data/datasources/gemini_remote_datasource.dart';
import 'package:mega_news/features/gemini/domain/repositories/i_gemini_repository.dart';

class GeminiRepositoryImpl implements IGeminiRepository {
  final IGeminiRemoteDataSource _dataSource;

  GeminiRepositoryImpl(this._dataSource);

  @override
  Future<String> generateText(String prompt) async {
    try {
      return await _dataSource.generateText(prompt);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(message: 'Gemini Repository Error: $e');
    }
  }
}
