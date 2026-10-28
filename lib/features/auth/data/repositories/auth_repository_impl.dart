import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      final data = response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : response;

      String? token;
      if (data['tokens'] is Map) {
        token = data['tokens']['accessToken'] ?? data['tokens']['token'];
      }
      token ??= data['accessToken'] ?? data['token'] ?? response['token'];

      if (token != null) {
        await StorageService.saveToken(token.toString());
      }

      final userData = data['user'] ?? response['user'] ?? data;
      final userModel = UserModel.fromJson(userData as Map<String, dynamic>);
      await StorageService.saveUserData(userModel.toJson());

      return Success(userModel);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<UserEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    required String registrationType,
    String? bmdcNumber,
  }) async {
    try {
      final response = await _remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobile: mobile,
        password: password,
        passwordConfirmation: passwordConfirmation,
        registrationType: registrationType,
        bmdcNumber: bmdcNumber,
      );

      final data = response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : response;

      String? token;
      if (data['tokens'] is Map) {
        token = data['tokens']['accessToken'] ?? data['tokens']['token'];
      }
      token ??= data['accessToken'] ?? data['token'] ?? response['token'];

      if (token != null) {
        await StorageService.saveToken(token.toString());
      }

      final userData = data['user'] ?? response['user'] ?? data;
      final userModel = UserModel.fromJson(userData as Map<String, dynamic>);
      await StorageService.saveUserData(userModel.toJson());

      return Success(userModel);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<bool>> logout() async {
    try {
      try {
        await _remoteDataSource.logout();
      } catch (_) {
        // Proceed with local logout regardless of network status
      }
      await StorageService.logout();
      return const Success(true);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<bool>> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Success(true);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<bool>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _remoteDataSource.verifyOtp(email: email, otp: otp);
      return const Success(true);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<bool>> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        email: email,
        newPassword: newPassword,
        otp: otp,
      );
      return const Success(true);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userData = await StorageService.getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }
}
