import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../presentation/viewmodels/pediatric_dose_viewmodel.dart';

class PediatricDoseScreen extends StatefulWidget {
  const PediatricDoseScreen({super.key});

  @override
  State<PediatricDoseScreen> createState() => _PediatricDoseScreenState();
}

class _PediatricDoseScreenState extends State<PediatricDoseScreen> {
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PediatricDoseViewModel>().init();
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<PediatricDoseViewModel>();
    if (vm.selectedMedicineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a medicine')),
      );
      return;
    }

    final weight = double.tryParse(_weightController.text);
    final age = int.tryParse(_ageController.text);
    if (weight == null || age == null) return;

    await vm.calculateDose(weightKg: weight, ageMonths: age);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pediatric Dose',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Consumer<PediatricDoseViewModel>(
        builder: (context, vm, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink, Colors.pink.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.baby,
                          color: Colors.white, size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Calculate Safe Dosage',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white)),
                            Text('Based on weight and age',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Medicine selector
                      _buildLabel('Select Medicine'),
                      const SizedBox(height: 8),
                      vm.isLoading
                          ? const LinearProgressIndicator()
                          : _buildMedicineDropdown(vm),
                      const SizedBox(height: 20),

                      // Weight
                      _buildLabel("Child's Weight (kg)"),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          hintText: 'e.g. 9.6',
                          prefixIcon: Icon(LucideIcons.weight),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter weight';
                          if (double.tryParse(v) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Age in months
                      _buildLabel('Child Age (months)'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'e.g. 12',
                          prefixIcon: Icon(LucideIcons.calendarDays),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter age';
                          if (int.tryParse(v) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Calculate button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: vm.isCalculating ? null : _calculate,
                          icon: vm.isCalculating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white),
                                )
                              : const Icon(LucideIcons.calculator),
                          label: Text(vm.isCalculating
                              ? 'Calculating...'
                              : 'Calculate Dose'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Error message
                if (vm.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.alertCircle,
                            color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(vm.errorMessage!,
                              style: const TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                ],

                // Result
                if (vm.calculationResult != null) ...[
                  const SizedBox(height: 28),
                  _buildResultCard(vm.calculationResult!),
                ],

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  Widget _buildMedicineDropdown(PediatricDoseViewModel vm) {
    return DropdownButtonFormField<dynamic>(
      initialValue: vm.selectedMedicineId,
      hint: const Text('Select a medicine'),
      isExpanded: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(LucideIcons.pill),
      ),
      items: vm.medicines.map<DropdownMenuItem<dynamic>>((med) {
        return DropdownMenuItem<dynamic>(
          value: med['medicineId'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(med['medicineName']?.toString() ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(med['formulation']?.toString() ?? '',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        );
      }).toList(),
      onChanged: (val) => vm.selectMedicine(val),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(LucideIcons.checkCircle,
                    color: Colors.green),
              ),
              const SizedBox(width: 12),
              const Text('Calculation Result',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.green)),
            ],
          ),
          const Divider(height: 24),
          _resultRow('Medicine', result['formulation']?.toString() ?? '-'),
          _resultRow('Indication', result['indication']?.toString() ?? '-'),
          _resultRow('Dose',
              '${result['doseMg'] ?? '-'} mg'),
          _resultRow('Volume', '${result['volumeMl'] ?? '-'} mL'),
          _resultRow('Route', result['route']?.toString() ?? '-'),
          _resultRow('Interval',
              'Every ${result['doseIntervalHours'] ?? '-'} hours'),
          _resultRow('Max Doses/24h',
              '${result['maxDosesPer24Hours'] ?? '-'} doses'),
          if (result['sourceReference'] != null &&
              result['sourceReference'].toString().isNotEmpty)
            _resultRow('Reference',
                result['sourceReference'].toString()),

          if (result['safetyChecks'] is Map) ...[
            const SizedBox(height: 12),
            const Text('Safety Checks',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...(result['safetyChecks'] as Map).entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      e.value == true
                          ? LucideIcons.checkCircle2
                          : LucideIcons.xCircle,
                      size: 16,
                      color:
                          e.value == true ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      e.key.toString().replaceAll('_', ' '),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: TextStyle(
                    fontSize: 13, color: Colors.grey[600])),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
