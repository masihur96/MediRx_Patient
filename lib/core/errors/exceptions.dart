/// Base application exception
class AppException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  AppException({
    required this.message,
    this.code,
    this.statusCode,
  });

  @override
  String toString() => 'AppException: $message (code: $code, statusCode: $statusCode)';
}

/// Server or API request exceptions
class ServerException extends AppException {
  ServerException({
    required super.message,
    super.code,
    super.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (statusCode: $statusCode)';
}

/// Local storage / Cache exceptions
class CacheException extends AppException {
  CacheException({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Network connectivity exceptions
class NetworkException extends AppException {
  NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.code,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Authentication and session exceptions
class AuthenticationException extends AppException {
  AuthenticationException({
    required super.message,
    super.code,
    super.statusCode = 401,
  });

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Unauthorized / Token expired exception
class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message = 'Session expired. Please log in again.',
    super.statusCode = 401,
  });

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Request timeout exception
class TimeoutException extends AppException {
  TimeoutException({
    super.message = 'Connection timed out. Please try again later.',
  });

  @override
  String toString() => 'TimeoutException: $message';
}
