import 'package:flutter/foundation.dart';
import '../../domain/repositories/hospital_repository.dart';

class HospitalViewModel extends ChangeNotifier {
  final HospitalRepository _repository;

  HospitalViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<dynamic> _hospitals = [];
  List<dynamic> get hospitals => _hospitals;

  List<dynamic> _filteredHospitals = [];
  List<dynamic> get filteredHospitals =>
      _filteredHospitals.isEmpty && _searchQuery.isEmpty
          ? _hospitals
          : _filteredHospitals;

  String _searchQuery = '';

  void search(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredHospitals = [];
    } else {
      _filteredHospitals = _hospitals.where((h) {
        final name =
            (h['hospital_name'] ?? '').toString().toLowerCase();
        final address = (h['address'] ?? '').toString().toLowerCase();
        final type =
            (h['hospital_type']?['name'] ?? '').toString().toLowerCase();
        return name.contains(_searchQuery) ||
            address.contains(_searchQuery) ||
            type.contains(_searchQuery);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> fetchHospitals() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getHospitals();
    if (result.isSuccess) {
      _hospitals = result.data ?? [];
      _filteredHospitals = [];
    } else {
      _errorMessage = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }
}
