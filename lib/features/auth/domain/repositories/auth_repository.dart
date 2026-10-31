import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

/// Abstract contract for Authentication repository
abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String identifier,
    required String password,
  });

  Future<Result<UserEntity>> getUserProfile({String? token, String? fallbackRole});

  Future<Result<String>> refreshToken({String? token});

  Future<Result<UserEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    required String registrationType,
    String? bmdcNumber,
  });

  Future<Result<bool>> logout();

  Future<Result<String>> forgotPassword({required String email});

  Future<Result<bool>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Result<bool>> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  });

  Future<UserEntity?> getCurrentUser();
}
