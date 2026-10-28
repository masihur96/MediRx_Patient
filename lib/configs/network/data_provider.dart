import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import '../../core/constants/apis.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/storage_service.dart';

/// Centralized Dio HTTP client for MediRx Patient
class DataProvider {
  final Dio _dio;
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  Dio get dio => _dio;

  DataProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: APIPath.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach Bearer token if available
          final token = await StorageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          log('--> ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          log('<-- ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (DioException error, handler) async {
          log('ERROR [${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');

          // Check for 401 Unauthorized for token refresh
          if (error.response?.statusCode == 401) {
            final refreshed = await _handleTokenRefresh();
            if (refreshed) {
              final token = await StorageService.getToken();
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              try {
                final response = await _dio.fetch(error.requestOptions);
                return handler.resolve(response);
              } on DioException catch (retryError) {
                return handler.next(retryError);
              }
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  Future<bool> _handleTokenRefresh() async {
    if (_isRefreshing) {
      return await (_refreshCompleter?.future ?? Future.value(false));
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _isRefreshing = false;
        _refreshCompleter?.complete(false);
        return false;
      }

      final refreshDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      final response = await refreshDio.post(
        APIPath.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newToken = response.data['accessToken'] ?? response.data['token'];
        if (newToken != null) {
          await StorageService.saveToken(newToken);
          _isRefreshing = false;
          _refreshCompleter?.complete(true);
          return true;
        }
      }
    } catch (e) {
      log('Token refresh error: $e');
    }

    _isRefreshing = false;
    _refreshCompleter?.complete(false);
    return false;
  }

  // ================= Generic Request Helpers =================

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.connectionError:
        return NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        String message = 'Server error occurred.';
        if (data is Map) {
          if (data['errors'] is Map && (data['errors'] as Map).isNotEmpty) {
            final errorsMap = data['errors'] as Map;
            final List<String> fieldErrors = [];
            errorsMap.forEach((_, value) {
              if (value is List && value.isNotEmpty) {
                fieldErrors.add(value.join(' '));
              } else if (value != null) {
                fieldErrors.add(value.toString());
              }
            });
            if (fieldErrors.isNotEmpty) {
              message = fieldErrors.join('\n');
            } else if (data['message'] != null) {
              message = data['message'].toString();
            }
          } else if (data['message'] != null) {
            message = data['message'].toString();
          }
        } else if (error.message != null) {
          message = error.message!;
        }
        if (statusCode == 401) {
          return UnauthorizedException(message: message, statusCode: statusCode);
        }
        return ServerException(message: message, statusCode: statusCode);
      default:
        return AppException(
          message: error.message ?? 'An unexpected error occurred.',
        );
    }
  }
}
