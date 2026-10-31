import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/logo_widget.dart';
import '../../../shared/widgets/app_snackbar.dart';
import 'forgot_otp_verification_screen.dart';
import 'viewmodels/auth_viewmodel.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  bool _isLoading = false;

  bool get _isEmail =>
      _identifierController.text.contains('@') &&
      _identifierController.text.contains('.');

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address.';
    }
    final trimmed = value.trim();
    final isEmail = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.[a-zA-Z]{2,}$').hasMatch(trimmed);
    if (!isEmail) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _identifierController.text.trim();

    setState(() => _isLoading = true);

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.forgotPassword(email: email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      final msg = authViewModel.successMessage ??
          'We have emailed your password reset link!';
      AppSnackBar.showSuccess(context, message: msg);

      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => ForgotOtpVerificationScreen(
            identifier: email,
            isEmail: true,
          ),
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    } else {
      final errorMsg = authViewModel.errorMessage ??
          "We can't find a user with that email address.";
      AppSnackBar.showError(context, message: errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : AppColors.primaryTeal,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MediRxLogo(size: 90, showText: false),
                  const SizedBox(height: 24),

                  // Lock icon badge
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: AppColors.primaryTeal,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headlineMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No worries! Enter your registered email address\nand we\'ll send you a password reset link.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: isDark ? Colors.grey[400] : AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Input field
                  TextFormField(
                    controller: _identifierController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validate,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Enter your email address',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[400] : AppColors.textGray,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      prefixIcon: Icon(
                        _isEmail ? Icons.email_outlined : Icons.phone_outlined,
                        color: AppColors.primaryTeal,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primaryTeal, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: AppColors.errorRed),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.errorRed, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Send OTP button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        disabledBackgroundColor:
                            AppColors.primaryTeal.withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Send Verification Code',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Back to login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back_rounded,
                          size: 14, color: AppColors.textGray),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Back to Login',
                          style: TextStyle(
                            color: AppColors.primaryTeal,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
