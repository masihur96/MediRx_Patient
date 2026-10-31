import 'package:flutter/foundation.dart';
import '../../data/doctor_models.dart';
import '../../domain/repositories/doctor_repository.dart';

class DoctorProfileViewModel extends ChangeNotifier {
  final DoctorRepository _repository;

  DoctorProfileViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DoctorProfile? _doctorProfile;
  DoctorProfile? get doctorProfile => _doctorProfile;

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

    // Default to '38' as requested
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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
