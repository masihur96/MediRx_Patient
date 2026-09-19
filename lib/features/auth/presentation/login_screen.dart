import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/presentation/dashboard_screen.dart';
import '../../doctor/presentation/doctor_dashboard_screen.dart';

enum _UserRole { patient, doctor }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  _UserRole _selectedRole = _UserRole.patient;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onRoleChanged(_UserRole role) {
    setState(() {
      _selectedRole = role;
      _emailController.clear();
      _passwordController.clear();
      // Pre-fill demo credentials
      if (role == _UserRole.doctor) {
        _emailController.text = 'doctor@medirx.com';
        _passwordController.text = 'doctor123';
      }
    });
  }

  void _handleLogin() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid credentials')),
      );
      return;
    }

    if (_selectedRole == _UserRole.doctor) {
      if (_emailController.text == 'doctor@medirx.com' && _passwordController.text == 'doctor123') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid doctor credentials. Use doctor@medirx.com / doctor123'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDoctor = _selectedRole == _UserRole.doctor;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryTeal, Color(0xFF00897B)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryTeal.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(LucideIcons.heartPulse, size: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'MediRx',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                    fontSize: 26,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Your Digital Health Platform',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // ─── Portal Selection ────────────────────────────────────────
                Text(
                  'Select Portal',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildRoleCard(_UserRole.patient, 'Patient\nPortal', LucideIcons.user, Colors.blue)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildRoleCard(_UserRole.doctor, 'Doctor\nPortal', LucideIcons.stethoscope, AppColors.primaryTeal)),
                  ],
                ),
                const SizedBox(height: 28),

                // ─── Login Form ──────────────────────────────────────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    key: ValueKey<_UserRole>(_selectedRole),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDoctor ? AppColors.primaryTeal.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: (isDoctor ? AppColors.primaryTeal : Colors.blue).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                isDoctor ? LucideIcons.stethoscope : LucideIcons.user,
                                color: isDoctor ? AppColors.primaryTeal : Colors.blue,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isDoctor ? 'Doctor Login' : 'Patient Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDoctor ? AppColors.primaryTeal : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        if (isDoctor) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryTeal.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.info, size: 14, color: AppColors.primaryTeal),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Demo: doctor@medirx.com / doctor123',
                                    style: TextStyle(fontSize: 11, color: AppColors.primaryTeal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: isDoctor ? 'Doctor Email' : 'Email',
                            prefixIcon: const Icon(LucideIcons.mail, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(LucideIcons.lock, size: 18),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye, size: 18),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDoctor ? AppColors.primaryTeal : Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              minimumSize: Size.zero,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(isDoctor ? LucideIcons.stethoscope : LucideIcons.logIn, color: Colors.white, size: 18),
                                const SizedBox(width: 10),
                                Text(
                                  isDoctor ? 'Login as Doctor' : 'Login',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 4,
                  children: [
                    Text('By logging in, you agree to our', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    GestureDetector(
                      onTap: () => _showLegalDialog('Terms & Conditions', 'Here are the Terms & Conditions...'),
                      child: const Text(
                        'Terms & Conditions',
                        style: TextStyle(color: AppColors.primaryTeal, fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                    ),
                    Text('and', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    GestureDetector(
                      onTap: () => _showLegalDialog('Privacy Policy', 'Here is the Privacy Policy...'),
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(color: AppColors.primaryTeal, fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(_UserRole role, String label, IconData icon, Color color) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => _onRoleChanged(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))]
              : [],
        ),
        child: Column(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.15) : Colors.grey.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? color : Colors.grey, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey[600],
                fontSize: 13,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? 20 : 0,
              height: 3,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLegalDialog(String title, String content) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(content),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal, foregroundColor: Colors.white),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
