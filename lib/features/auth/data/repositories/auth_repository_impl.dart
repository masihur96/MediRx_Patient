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
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        identifier: identifier,
        password: password,
      );

      // Check if backend returned success == false in 200 OK response
      if (response['success'] == false) {
        return Error(
          response['message']?.toString() ?? 'Login failed',
          statusCode: response['code'] is int ? response['code'] as int : 400,
        );
      }

      final data = response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : response;

      String? token;
      if (data['tokens'] is Map) {
        token = data['tokens']['accessToken'] ?? data['tokens']['token'];
      }
      token ??= data['accessToken'] ??
          data['token'] ??
          response['token'] ??
          data['access_token'] ??
          data['jwt'];

      if (token != null) {
        await StorageService.saveToken(token.toString());
      }

      String? refreshToken;
      if (data['tokens'] is Map) {
        refreshToken = data['tokens']['refreshToken'];
      }
      refreshToken ??= data['refreshToken'] ??
          data['refresh_token'] ??
          response['refreshToken'];

      if (refreshToken != null) {
        await StorageService.saveRefreshToken(refreshToken.toString());
      }

      UserModel? userModel;
      try {
        final profileResult = await getUserProfile(token: token);
        if (profileResult.isSuccess && profileResult.data != null) {
          userModel = profileResult.data is UserModel
              ? profileResult.data as UserModel
              : UserModel.fromJson((profileResult.data as dynamic).toJson());
        }
      } catch (_) {}

      if (userModel == null) {
        final userData = data['user'] ??
            response['user'] ??
            (data.containsKey('email') ||
                    data.containsKey('id') ||
                    data.containsKey('name') ||
                    data.containsKey('FirstName')
                ? data
                : null);

        if (userData is Map<String, dynamic>) {
          userModel = UserModel.fromJson(userData);
        } else {
          userModel = UserModel(
            id: data['id']?.toString() ?? '',
            fullName: data['name'] ?? identifier,
            email: identifier.contains('@') ? identifier : '',
            phone: !identifier.contains('@') ? identifier : null,
          );
        }
        await StorageService.saveUserData(userModel.toJson());
      }

      return Success(userModel);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<UserEntity>> getUserProfile({String? token}) async {
    try {
      final activeToken = token ?? await StorageService.getToken();
      final response =
          await _remoteDataSource.getUserProfile(token: activeToken);

      if (response['success'] == false) {
        return Error(
          response['message']?.toString() ?? 'Failed to fetch user data',
          statusCode: response['code'] is int ? response['code'] as int : 400,
        );
      }

      final profileData = response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : response;

      final userModel = UserModel.fromJson(profileData);
      await StorageService.saveUserData(userModel.toJson());

      return Success(userModel);
    } on AppException catch (e) {
      return Error(e.message, statusCode: e.statusCode ?? 400);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<String>> refreshToken({String? token}) async {
    try {
      final activeToken = token ?? await StorageService.getToken();
      final response = await _remoteDataSource.refreshToken(token: activeToken);

      final data = response['data'] is Map<String, dynamic>
          ? response['data'] as Map<String, dynamic>
          : response;

      String? newToken;
      if (data['tokens'] is Map) {
        newToken = data['tokens']['accessToken']?.toString() ??
            data['tokens']['token']?.toString();
      }
      newToken ??= data['accessToken']?.toString() ??
          data['access_token']?.toString() ??
          data['token']?.toString() ??
          response['token']?.toString();

      if (newToken != null && newToken.isNotEmpty) {
        await StorageService.saveToken(newToken);
        return Success(newToken);
      }
      return const Error('Failed to parse refreshed token');
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
      final token = await StorageService.getToken();
      try {
        if (token != null && token.isNotEmpty) {
          await _remoteDataSource.logout(token: token);
        }
      } catch (_) {
        // Proceed with local logout regardless of network status
      }
      await StorageService.logout();
      return const Success(true);
    } catch (e) {
      await StorageService.logout();
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
