import 'package:flutter/foundation.dart';
import '../../domain/repositories/vaccine_repository.dart';

class VaccineViewModel extends ChangeNotifier {
  final VaccineRepository _repository;

  VaccineViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<dynamic> _vaccines = [];
  List<dynamic> get vaccines => _vaccines;

  List<dynamic> _vaccinations = [];
  List<dynamic> get vaccinations => _vaccinations;

  List<dynamic> _schedules = [];
  List<dynamic> get schedules => _schedules;

  Future<void> fetchVaccines() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getVaccines();
    if (result.isSuccess) {
      _vaccines = result.data ?? [];
    } else {
      _errorMessage = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchVaccinations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getVaccinations();
    if (result.isSuccess) {
      _vaccinations = result.data ?? [];
    } else {
      _errorMessage = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSchedules() async {
    final result = await _repository.getVaccinationSchedules();
    if (result.isSuccess) {
      _schedules = result.data ?? [];
    }
    notifyListeners();
  }

  Future<void> init() async {
    await Future.wait([fetchVaccines(), fetchVaccinations(), fetchSchedules()]);
  }
}
