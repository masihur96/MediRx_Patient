import 'package:dio/dio.dart';
import '../../../../configs/network/data_provider.dart';
import '../../../../core/constants/apis.dart';
import '../../../../core/utils/storage_service.dart';

abstract class DoctorRemoteDataSource {
  Future<Map<String, dynamic>> getDoctorProfile(dynamic doctorId, {String? token});
  Future<List<dynamic>> getDoctors({String? specialty, String? token});
  Future<Map<String, dynamic>> updateDoctorProfile(
    dynamic doctorId,
    Map<String, dynamic> data, {
    String? token,
    String? imagePath,
  });
  Future<List<dynamic>> getMedicalSpecialties({String? token});
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

  @override
  Future<Map<String, dynamic>> updateDoctorProfile(
    dynamic doctorId,
    Map<String, dynamic> data, {
    String? token,
    String? imagePath,
  }) async {
    final activeToken = (token != null && token.isNotEmpty)
        ? token
        : ((await StorageService.getToken()) ?? fallbackDoctorToken);

    final formData = FormData();
    formData.fields.add(const MapEntry('_method', 'PUT'));

    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is List) {
        for (final item in value) {
          formData.fields.add(MapEntry('$key[]', item.toString()));
        }
      } else if (value is Map) {
        for (final subEntry in value.entries) {
          if (subEntry.value != null && subEntry.value.toString().isNotEmpty) {
            formData.fields.add(
              MapEntry('$key[${subEntry.key}]', subEntry.value.toString()),
            );
          }
        }
      } else if (value != null) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    }

    if (imagePath != null && imagePath.isNotEmpty) {
      formData.files.add(MapEntry(
        'profile_image',
        await MultipartFile.fromFile(imagePath),
      ));
    }

    final response = await _dataProvider.post(
      APIPath.doctorDetail(doctorId),
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $activeToken',
          'X-HTTP-Method-Override': 'PUT',
        },
      ),
    );

    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getMedicalSpecialties({String? token}) async {
    final activeToken = (token != null && token.isNotEmpty)
        ? token
        : ((await StorageService.getToken()) ?? fallbackDoctorToken);

    final response = await _dataProvider.get(
      APIPath.medicalSpecialties,
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
