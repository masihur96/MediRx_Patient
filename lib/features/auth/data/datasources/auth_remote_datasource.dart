import 'package:dio/dio.dart';
import '../../../../configs/network/data_provider.dart';
import '../../../../core/constants/apis.dart';
import '../../../../core/utils/storage_service.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  });

  Future<Map<String, dynamic>> getUserProfile({String? token});

  Future<Map<String, dynamic>> refreshToken({String? token});

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    required String registrationType,
    String? bmdcNumber,
  });

  Future<void> logout({String? token});

  Future<Map<String, dynamic>> forgotPassword({required String email});

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
    required String identifier,
    required String password,
  }) async {
    final response = await _dataProvider.post(
      APIPath.login,
      data: {
        'identifier': identifier,
        'password': password,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getUserProfile({String? token}) async {
    final response = await _dataProvider.get(
      APIPath.user,
      options: token != null && token.isNotEmpty
          ? Options(headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            })
          : Options(headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            }),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> refreshToken({String? token}) async {
    final activeToken = token ?? await StorageService.getToken();
    final response = await _dataProvider.post(
      APIPath.refreshToken,
      options: Options(headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (activeToken != null && activeToken.isNotEmpty)
          'Authorization': 'Bearer $activeToken',
      }),
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    required String registrationType,
    String? bmdcNumber,
  }) async {
    final payload = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'registration_type': registrationType,
    };
    if (registrationType == 'Doctor' && bmdcNumber != null && bmdcNumber.isNotEmpty) {
      payload['bmdc_number'] = bmdcNumber;
    }

    final response = await _dataProvider.post(
      APIPath.register,
      data: payload,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> logout({String? token}) async {
    final activeToken = token ?? await StorageService.getToken();
    await _dataProvider.post(
      APIPath.logout,
      options: Options(headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (activeToken != null && activeToken.isNotEmpty)
          'Authorization': 'Bearer $activeToken',
      }),
    );
  }

  @override
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    final response = await _dataProvider.post(
      APIPath.forgotPassword,
      data: {'email': email},
    );
    return response.data as Map<String, dynamic>;
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
