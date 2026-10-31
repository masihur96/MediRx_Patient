import 'package:flutter/foundation.dart';
import '../../domain/repositories/pediatric_dose_repository.dart';

class PediatricDoseViewModel extends ChangeNotifier {
  final PediatricDoseRepository _repository;

  PediatricDoseViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCalculating = false;
  bool get isCalculating => _isCalculating;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<dynamic> _medicines = [];
  List<dynamic> get medicines => _medicines;

  List<dynamic> _recentCalculations = [];
  List<dynamic> get recentCalculations => _recentCalculations;

  Map<String, dynamic>? _calculationResult;
  Map<String, dynamic>? get calculationResult => _calculationResult;

  Map<String, dynamic>? get selectedMedicine {
    if (_selectedMedicineId == null) return null;
    try {
      return _medicines.firstWhere(
        (m) => m['medicineId'] == _selectedMedicineId,
      ) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  dynamic _selectedMedicineId;
  dynamic get selectedMedicineId => _selectedMedicineId;

  void selectMedicine(dynamic medicineId) {
    _selectedMedicineId = medicineId;
    _calculationResult = null;
    notifyListeners();
  }

  Future<void> fetchMedicines() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getMedicines();
    if (result.isSuccess) {
      _medicines = result.data ?? [];
    } else {
      _errorMessage = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchRecentCalculations() async {
    final result = await _repository.getRecentCalculations();
    if (result.isSuccess) {
      _recentCalculations = result.data ?? [];
      notifyListeners();
    }
  }

  Future<bool> calculateDose({
    required double weightKg,
    required int ageMonths,
  }) async {
    final medicine = selectedMedicine;
    if (medicine == null) {
      _errorMessage = 'Please select a medicine';
      notifyListeners();
      return false;
    }

    _isCalculating = true;
    _errorMessage = null;
    _calculationResult = null;
    notifyListeners();

    final params = {
      'medicineId': medicine['medicineId'],
      'childWeightKg': weightKg,
      'childAgeMonths': ageMonths,
      'indication': medicine['indication'],
      'formulation': medicine['formulation'],
    };

    final result = await _repository.calculateDose(params);
    _isCalculating = false;

    if (result.isSuccess) {
      _calculationResult = result.data;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> init() async {
    await Future.wait([fetchMedicines(), fetchRecentCalculations()]);
  }
}
