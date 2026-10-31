import 'package:flutter/foundation.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardRepository _repository;

  DashboardViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _overviewData;
  Map<String, dynamic>? get overviewData => _overviewData;

  Map<String, dynamic>? get patient =>
      _overviewData?['patient'] as Map<String, dynamic>?;

  num get adherenceRate =>
      (_overviewData?['adherenceRate'] as num?) ?? 0;

  Map<String, dynamic>? get todayMedsSummary =>
      _overviewData?['todayMedsSummary'] as Map<String, dynamic>?;

  List<dynamic> get todayMedications =>
      (_overviewData?['todayMedications'] as List<dynamic>?) ?? [];

  Map<String, dynamic>? get quickStats =>
      _overviewData?['quickStats'] as Map<String, dynamic>?;

  Future<void> fetchDashboardOverview() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getDashboardOverview();
    if (result.isSuccess && result.data != null) {
      _overviewData = result.data;
      _errorMessage = null;
    } else {
      _errorMessage = result.error ?? 'Failed to load dashboard data';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await fetchDashboardOverview();
  }
}
