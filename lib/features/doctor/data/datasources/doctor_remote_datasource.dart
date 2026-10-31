import 'package:dio/dio.dart';
import '../../../../configs/network/data_provider.dart';
import '../../../../core/constants/apis.dart';
import '../../../../core/utils/storage_service.dart';

abstract class DoctorRemoteDataSource {
  Future<Map<String, dynamic>> getDoctorProfile(dynamic doctorId, {String? token});
  Future<List<dynamic>> getDoctors({String? specialty, String? token});
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final DataProvider _dataProvider;

  // Fallback JWT provided for Doctor credentials
  static const String fallbackDoctorToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL21lZGlyeC51bmlwZXhlbC5vcmcvYXBpL3YxL2F1dGgvbG9naW4iLCJpYXQiOjE3OTM0NjYzODEsImV4cCI6MTc5MzQ2OTk4MSwibmJmIjoxNzkzNDY2MzgxLCJqdGkiOiJMN2FuQkRadGUxa2FlWElhIiwic3ViIjoiMzgiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.cZMnfa1TiNHhnnhhrQ6bumFmS50CWpe6WTVGTuBUizs';

  DoctorRemoteDataSourceImpl(this._dataProvider);

  @override
  Future<Map<String, dynamic>> getDoctorProfile(dynamic doctorId, {String? token}) async {
    final activeToken = (token != null && token.isNotEmpty)
        ? token
        : ((await StorageService.getToken()) ?? fallbackDoctorToken);

    final response = await _dataProvider.get(
      APIPath.doctorDetail(doctorId),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $activeToken',
        },
      ),
    );

    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getDoctors({String? specialty, String? token}) async {
    final activeToken = (token != null && token.isNotEmpty)
        ? token
        : ((await StorageService.getToken()) ?? fallbackDoctorToken);

    final response = await _dataProvider.get(
      APIPath.doctors,
      queryParameters: specialty != null && specialty.isNotEmpty ? {'specialty': specialty} : null,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $activeToken',
        },
      ),
    );

    final data = response.data;
    if (data is Map && data['data'] is List) return data['data'] as List;
    if (data is List) return data;
    return [];
  }
}
