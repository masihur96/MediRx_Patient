import 'package:flutter/foundation.dart';
import '../../data/doctor_models.dart';
import '../../domain/repositories/doctor_repository.dart';

class DoctorProfileViewModel extends ChangeNotifier {
  final DoctorRepository _repository;

  DoctorProfileViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  bool _isLoadingSpecialties = false;
  bool get isLoadingSpecialties => _isLoadingSpecialties;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _updateErrorMessage;
  String? get updateErrorMessage => _updateErrorMessage;

  DoctorProfile? _doctorProfile;
  DoctorProfile? get doctorProfile => _doctorProfile;

  List<Map<String, dynamic>> _specialties = [];
  List<Map<String, dynamic>> get specialties => _specialties;

  Future<void> fetchDoctorProfile({
    String? doctorId,
    String? token,
    bool showLoading = true,
  }) async {
    if (showLoading) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    final targetId = (doctorId != null && doctorId.trim().isNotEmpty)
        ? doctorId.trim()
        : '38';

    final result = await _repository.getDoctorDetails(targetId, token: token);

    if (result.isSuccess && result.data != null) {
      _doctorProfile = result.data;
      _errorMessage = null;
    } else {
      _errorMessage = result.error ?? 'Failed to load doctor profile';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSpecialties({String? token}) async {
    if (_specialties.isNotEmpty) return;
    _isLoadingSpecialties = true;
    notifyListeners();

    final result = await _repository.getSpecialties(token: token);
    if (result.isSuccess && result.data != null) {
      _specialties = result.data!;
    }

    _isLoadingSpecialties = false;
    notifyListeners();
  }

  Future<bool> updateDoctorProfile({
    required String doctorId,
    required Map<String, dynamic> data,
    String? imagePath,
    String? token,
  }) async {
    _isUpdating = true;
    _updateErrorMessage = null;
    notifyListeners();

    final targetId = doctorId.trim().isNotEmpty ? doctorId.trim() : '38';

    final result = await _repository.updateDoctorProfile(
      targetId,
      data,
      imagePath: imagePath,
      token: token,
    );

    _isUpdating = false;

    if (result.isSuccess && result.data != null) {
      _doctorProfile = result.data;
      _updateErrorMessage = null;
      notifyListeners();
      return true;
    } else {
      _updateErrorMessage = result.error ?? 'Failed to update doctor profile';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    _updateErrorMessage = null;
    notifyListeners();
  }
}
