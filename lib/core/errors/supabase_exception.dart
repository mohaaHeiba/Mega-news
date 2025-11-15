abstract class SupabaseException implements Exception {
  final String message;
  final String? code;

  const SupabaseException(this.message, [this.code]);

  @override
  String toString() => '$runtimeType: $message';
}

class AuthException extends SupabaseException {
  const AuthException(super.message, [super.code]);
}

class UserAlreadyExistsException extends AuthException {
  const UserAlreadyExistsException(String message)
    : super(message, 'user_already_exists');
}

class MissingDataException extends AuthException {
  const MissingDataException(String message) : super(message, 'missing_data');
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException(String message)
    : super(message, 'invalid_credentials');
}

class NetworkException extends SupabaseException {
  const NetworkException(super.message);
}

class UnknownException extends SupabaseException {
  const UnknownException([String message = 'Unknown error occurred'])
    : super(message, 'unknown_error');
}

class AuthInvalidCredentialsException extends AuthException {
  const AuthInvalidCredentialsException(String message)
    : super(message, 'invalid_credentials');
}
