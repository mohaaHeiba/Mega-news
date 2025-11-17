/// Base class for all API-related exceptions.
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() {
    final code = statusCode != null ? ' (HTTP $statusCode)' : '';
    return '[$runtimeType] $message$code';
  }
}

/// Thrown for server-side errors (HTTP 5xx).
class ServerException extends ApiException {
  ServerException({
    super.message = "Internal server error",
    super.statusCode = 500,
  });
}

/// Thrown when a resource is not found (HTTP 404).
class NotFoundException extends ApiException {
  NotFoundException({
    super.message = "Resource not found",
    super.statusCode = 404,
  });
}

/// Thrown for bad requests from the client (HTTP 400).
class BadRequestException extends ApiException {
  BadRequestException({super.message = "Bad request", super.statusCode = 400});
}

/// Thrown for unauthorized access (HTTP 401).
class UnauthorizedException extends ApiException {
  UnauthorizedException({
    super.message = "Unauthorized access",
    super.statusCode = 401,
  });
}

/// Thrown when access is forbidden (HTTP 403).
class ForbiddenException extends ApiException {
  ForbiddenException({
    super.message = "Access forbidden. Please check your API key.",
    super.statusCode = 403,
  });
}

/// Thrown when the API rate limit is exceeded (HTTP 429).
class RateLimitException extends ApiException {
  final Duration? retryAfter;

  RateLimitException({
    super.message = "Too many requests. Please try again later.",
    super.statusCode = 429,
    this.retryAfter,
  });
}

/// Thrown for network connectivity issues or timeouts.
class NetworkException extends ApiException {
  NetworkException({super.message = "No internet connection"});
}

/// Thrown when a request is actively cancelled.
class RequestCancelledException extends ApiException {
  RequestCancelledException({super.message = "Request was cancelled"});
}

/// Thrown for any other unknown error.
class UnknownException extends ApiException {
  UnknownException({super.message = "An unknown error occurred"});
}
