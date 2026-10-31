import 'package:flutter/foundation.dart';
import '../../domain/repositories/medication_repository.dart';

class MedicationViewModel extends ChangeNotifier {
  final MedicationRepository _repository;

  MedicationViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isMarkingLog = false;
  bool get isMarkingLog => _isMarkingLog;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<dynamic> _medications = [];
  List<dynamic> get medications => _medications;

  List<dynamic> _prescriptions = [];
  List<dynamic> get prescriptions => _prescriptions;

  Map<String, dynamic>? _medicationsDashboard;
  Map<String, dynamic>? get medicationsDashboard => _medicationsDashboard;

  List<dynamic> get todayMedications =>
      (_medicationsDashboard?['todayMedications'] as List<dynamic>?) ?? [];

  Future<void> fetchMedications({int page = 1}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getMedications(page: page);
    if (result.isSuccess) {
      _medications = result.data ?? [];
    } else {
      _errorMessage = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPrescriptions({int page = 1}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getPrescriptions();
    if (result.isSuccess) {
      _prescriptions = result.data ?? [];
    } else {
      _errorMessage = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMedicationsDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getMedicationsDashboard();
    if (result.isSuccess) {
      _medicationsDashboard = result.data;
    } else {
      _errorMessage = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> markTaken(dynamic logId) async {
    _isMarkingLog = true;
    notifyListeners();

    final result = await _repository.markMedicationTaken(logId);
    _isMarkingLog = false;
    notifyListeners();

    if (result.isSuccess) {
      await fetchMedicationsDashboard();
      return true;
    }
    return false;
  }

  Future<bool> markSkipped(dynamic logId) async {
    _isMarkingLog = true;
    notifyListeners();

    final result = await _repository.markMedicationSkipped(logId);
    _isMarkingLog = false;
    notifyListeners();

    if (result.isSuccess) {
      await fetchMedicationsDashboard();
      return true;
    }
    return false;
  }

  Future<bool> markSnoozed(dynamic logId) async {
    _isMarkingLog = true;
    notifyListeners();

    final result = await _repository.markMedicationSnoozed(logId);
    _isMarkingLog = false;
    notifyListeners();

    if (result.isSuccess) {
      await fetchMedicationsDashboard();
      return true;
    }
    return false;
  }

  Future<void> init() async {
    await Future.wait([
      fetchMedications(),
      fetchPrescriptions(),
      fetchMedicationsDashboard(),
    ]);
  }
}
