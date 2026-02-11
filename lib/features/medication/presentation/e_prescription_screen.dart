import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class EPrescriptionScreen extends StatefulWidget {
  const EPrescriptionScreen({super.key});

  @override
  State<EPrescriptionScreen> createState() => _EPrescriptionScreenState();
}

class _EPrescriptionScreenState extends State<EPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _fetchPrescription() {
    if (_formKey.currentState!.validate()) {
      // Logic to fetch prescription
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetching prescription...')),
      );
      // Simulate fetch delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Prescription fetched successfully!')),
           );
           Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Prescription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter your E-Prescription ID or Code to fetch details directly from your doctor.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'Prescription ID / Code',
                  hintText: 'e.g. RX-12345678',
                  prefixIcon: const Icon(LucideIcons.fileDigit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a prescription ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _fetchPrescription,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Fetch Prescription'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
