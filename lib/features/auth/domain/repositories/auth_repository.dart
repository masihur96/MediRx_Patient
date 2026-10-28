import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

/// Abstract contract for Authentication repository
abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  });

  Future<Result<bool>> logout();

  Future<Result<bool>> forgotPassword({required String email});

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
