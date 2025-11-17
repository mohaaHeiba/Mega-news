import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:mega_news/core/errors/api_exception.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio, {bool enableRetry = true, bool enableRateLimit = true}) {
    _dio.options.connectTimeout = const Duration(milliseconds: 10000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 10000);

    // the RetryInterceptor if enabled for if conection faild
    if (enableRetry || enableRateLimit) {
      _dio.interceptors.add(
        RetryInterceptor(
          dio: _dio,
          logPrint: (message) {},
          retries: 3, // Number of retries
          retryDelays: const [
            Duration(seconds: 1), // 1st retry
            Duration(seconds: 2), // 2nd retry
            Duration(seconds: 3), // 3rd retry
          ],
        ),
      );
    }
  }

  //================Get===============
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw UnknownException(message: 'An unexpected error occurred: $e');
    }
  }

  ApiException _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return NetworkException(
        message: 'Connection timed out. Check your internet connection.',
      );
    }

    if (e.type == DioExceptionType.cancel) {
      return RequestCancelledException();
    }

    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown) {
      // This often happens when there is no internet connection.
      return NetworkException(
        message: 'Connection error. Check your internet connection.',
      );
    }

    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      String message = 'Server returned an error';
      if (responseData is Map) {
        message =
            responseData['message'] ??
            responseData['error'] ??
            responseData['status'] ??
            message;
      } else if (responseData is String && responseData.isNotEmpty) {
        message = responseData;
      }

      if (statusCode == 400) {
        return BadRequestException(message: message, statusCode: statusCode);
      }
      if (statusCode == 401) {
        return UnauthorizedException(
          message: message.isNotEmpty
              ? message
              : 'Unauthorized. Please check your credentials.',
          statusCode: statusCode,
        );
      }
      if (statusCode == 403) {
        return ForbiddenException(
          message: message.isNotEmpty
              ? message
              : 'Access forbidden. Please check your API key.',
          statusCode: statusCode,
        );
      }
      if (statusCode == 404) {
        return NotFoundException(message: message, statusCode: statusCode);
      }
      if (statusCode == 429) {
        Duration? retryAfter;
        final retryAfterHeader = e.response?.headers.value('retry-after');
        if (retryAfterHeader != null) {
          final seconds = int.tryParse(retryAfterHeader);
          if (seconds != null) {
            retryAfter = Duration(seconds: seconds);
          }
        }
        return RateLimitException(
          message: message.isNotEmpty
              ? message
              : 'Too many requests. Please try again later.',
          statusCode: statusCode,
          retryAfter: retryAfter,
        );
      }

      // Catch-all for other 4xx client errors
      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        return BadRequestException(message: message, statusCode: statusCode);
      }

      // Catch-all for 5xx server errors
      if (statusCode != null && statusCode >= 500) {
        return ServerException(message: message, statusCode: statusCode);
      }
    }

    return UnknownException(message: e.message ?? 'An unknown error occurred');
  }
}
