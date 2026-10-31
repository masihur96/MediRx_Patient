import 'package:flutter/material.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthRepository _authRepository;

  AuthViewModel({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _authRepository = authRepository;

  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<void> initAuth() async {
    _currentUser = await _authRepository.getCurrentUser();
    notifyListeners();
  }

  Future<UserEntity?> getCurrentUser() async {
    _currentUser = await _authRepository.getCurrentUser();
    notifyListeners();
    return _currentUser;
  }

  Future<bool> fetchUserProfile({String? token}) async {
    _setLoading(true);
    _errorMessage = null;

    var result = await _authRepository.getUserProfile(token: token);

    // If 401 Unauthorized, attempt explicit token refresh and retry
    if (!result.isSuccess && result.statusCode == 401) {
      final refreshResult = await _authRepository.refreshToken();
      if (refreshResult.isSuccess) {
        result =
            await _authRepository.getUserProfile(token: refreshResult.data);
      }
    }

    _setLoading(false);

    if (result.isSuccess) {
      _currentUser = result.data;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> refreshToken() async {
    _setLoading(true);
    _errorMessage = null;

    final result = await _authRepository.refreshToken();

    _setLoading(false);

    if (result.isSuccess) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = result.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await _loginUseCase(
      LoginParams(identifier: identifier, password: password),
    );

    _setLoading(false);

    if (result.isSuccess) {
      _currentUser = result.data;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String passwordConfirmation,
    required String registrationType,
    String? bmdcNumber,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final result = await _registerUseCase(
      RegisterParams(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobile: mobile,
        password: password,
        passwordConfirmation: passwordConfirmation,
        registrationType: registrationType,
        bmdcNumber: bmdcNumber,
      ),
    );

    _setLoading(false);

    if (result.isSuccess) {
      _currentUser = result.data;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    _setLoading(true);
    _errorMessage = null;
    _successMessage = null;

    final result = await _authRepository.forgotPassword(email: email);

    _setLoading(false);

    if (result.isSuccess) {
      _successMessage = result.data;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    await _logoutUseCase(const NoParams());
    _currentUser = null;
    _setLoading(false);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
