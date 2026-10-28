import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configs/route_generator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/string_utils.dart';
import '../../../shared/widgets/app_snackbar.dart';
import 'viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bmdcController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _selectedRoleIndex = 1; // Default: 0 = Doctor, 1 = Patient
  final List<String> _roles = ['Doctor', 'Patient'];

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bmdcController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isDoctor => _selectedRoleIndex == 0;
  String get _registrationType => _roles[_selectedRoleIndex];

  Future<void> _handleRegister() async {
    if (!_agreeToTerms) {
      AppSnackBar.showError(
        context,
        message: 'Please agree to the Terms & Conditions and Privacy Policy.',
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final success = await authViewModel.register(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      mobile: _mobileController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
      registrationType: _registrationType,
      bmdcNumber: _isDoctor ? _bmdcController.text.trim() : null,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      AppSnackBar.showSuccess(
        context,
        message: 'Account created successfully! Welcome to MediRx.',
      );

      // Navigate to corresponding dashboard or home
      if (_isDoctor) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteGenerator.doctorHome,
          (route) => false,
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteGenerator.dashboard,
          (route) => false,
        );
      }
    } else {
      final errorMessage = authViewModel.errorMessage ??
          'Registration failed. Please check your details and try again.';
      AppSnackBar.showError(context, message: errorMessage);
    }
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.textLight : AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[400] : AppColors.textGray,
            fontSize: 14,
          ),
          filled: true,
          fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.transparent : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryTeal,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.errorRed),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.textGray,
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with back button and horizontal branding logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).iconTheme.color,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.health_and_safety,
                          color: AppColors.primaryTeal,
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Medi',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                        Text(
                          'Rx',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                        SizedBox(width: 40), // Balance the back button
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Registration',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textLight : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Role Selector (Doctor / Patient)
                      Container(
                        height: 44,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.mint,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: List.generate(_roles.length, (index) {
                            final isSelected = _selectedRoleIndex == index;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedRoleIndex = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryTeal
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _roles[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : (isDark ? AppColors.textLight : AppColors.primaryTeal),
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // First Name & Last Name
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildFormField(
                              controller: _firstNameController,
                              hintText: 'First Name',
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFormField(
                              controller: _lastNameController,
                              hintText: 'Last Name',
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      // BMDC Number (Only for Doctor)
                      if (_isDoctor)
                        _buildFormField(
                          controller: _bmdcController,
                          hintText: 'BMDC Number (e.g. AC-54246)',
                          validator: (val) {
                            if (_isDoctor && (val == null || val.trim().isEmpty)) {
                              return 'BMDC number is required for doctors';
                            }
                            return null;
                          },
                        ),

                      // Email Address
                      _buildFormField(
                        controller: _emailController,
                        hintText: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your email address.';
                          }
                          if (!StringUtils.isValidEmail(val.trim())) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                      ),

                      // Mobile Number
                      _buildFormField(
                        controller: _mobileController,
                        hintText: 'Mobile Number (e.g. 017XXXXXXXX)',
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your mobile number.';
                          }
                          if (val.trim().length < 10) {
                            return 'Enter a valid mobile number.';
                          }
                          return null;
                        },
                      ),

                      // Password
                      _buildFormField(
                        controller: _passwordController,
                        hintText: 'Create Password',
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter a password.';
                          }
                          if (val.length < 6) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                      ),

                      // Confirm Password
                      _buildFormField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        isPassword: true,
                        obscureText: _obscureConfirmPassword,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please confirm your password.';
                          }
                          if (val != _passwordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),

                      // Terms & Conditions Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                              activeColor: AppColors.primaryTeal,
                              side: const BorderSide(color: AppColors.textGray),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                text: 'I agree to the ',
                                style: TextStyle(
                                  color: AppColors.textGray,
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: TextStyle(
                                      color: AppColors.primaryTeal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy.',
                                    style: TextStyle(
                                      color: AppColors.primaryTeal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (_agreeToTerms && !_isSubmitting)
                              ? _handleRegister
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            disabledBackgroundColor:
                                AppColors.primaryTeal.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Login.',
                              style: TextStyle(
                                color: AppColors.primaryTeal,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
