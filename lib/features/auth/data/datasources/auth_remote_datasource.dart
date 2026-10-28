import '../../../../configs/network/data_provider.dart';
import '../../../../core/constants/apis.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  });

  Future<void> logout();

  Future<void> forgotPassword({required String email});

  Future<void> verifyOtp({
    required String email,
    required String otp,
  });

  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DataProvider _dataProvider;

  AuthRemoteDataSourceImpl(this._dataProvider);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dataProvider.post(
      APIPath.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _dataProvider.post(
      APIPath.register,
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> logout() async {
    await _dataProvider.post(APIPath.logout);
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _dataProvider.post(
      APIPath.forgotPassword,
      data: {'email': email},
    );
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await _dataProvider.post(
      APIPath.verifyOtp,
      data: {'email': email, 'otp': otp},
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) async {
    await _dataProvider.post(
      APIPath.resetPassword,
      data: {
        'email': email,
        'newPassword': newPassword,
        'otp': otp,
      },
    );
  }
}
