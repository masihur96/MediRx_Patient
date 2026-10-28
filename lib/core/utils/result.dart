/// Generic Result type representing Success or Error
abstract class Result<T> {
  const Result();

  bool get isSuccess;
  bool get isError;

  T? get data;
  String? get error;
  int? get statusCode;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String error, int? statusCode) onError,
  }) {
    if (isSuccess) {
      return onSuccess(data as T);
    } else {
      return onError(error ?? 'An unknown error occurred', statusCode);
    }
  }
}

class Success<T> extends Result<T> {
  final T _data;
  final int _statusCode;

  const Success(this._data, {int statusCode = 200}) : _statusCode = statusCode;

  @override
  bool get isSuccess => true;

  @override
  bool get isError => false;

  @override
  T get data => _data;

  @override
  String? get error => null;

  @override
  int get statusCode => _statusCode;
}

class Error<T> extends Result<T> {
  final String _error;
  final int _statusCode;

  const Error(this._error, {int statusCode = 400}) : _statusCode = statusCode;

  @override
  bool get isSuccess => false;

  @override
  bool get isError => true;

  @override
  T? get data => null;

  @override
  String get error => _error;

  @override
  int get statusCode => _statusCode;
}
